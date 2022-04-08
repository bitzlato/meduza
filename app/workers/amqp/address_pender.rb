# frozen_string_literal: true

module AMQP
  class AddressPender < Base
    def process(payload, metadata)
      logger.tagged('AddressPender') do
        logger.info "process payload=#{payload}, metadata=#{metadata}"
        aa = AddressAnalysis.find_by(address: payload.fetch('address'), cc_code: payload.fetch('cc_code'))
        if aa.present?
          payload = {
            address_transaction: aa.address,
            cc_code: aa.cc_code,
            action: aa.analysis_result.pass? ? :pass : :block,
            analysis_result_id: aa.analysis_result_id,
            from: :AddressPender
          }
          payload.merge! address_analysis_id: aa.id if aa.present?
          properties = { correlation_id: metadata.correlation_id, routing_key: metadata.reply_to }
          logger.info "rpc_callback with payload #{payload} and properties #{properties}"
          AMQP::Queue.publish :meduza, payload, properties
        else
          attrs = {
            meta:                payload.fetch('meta', {}),
            type:                payload.fetch('type', :address),
          }
          begin
            logger.info "find_or_create PendingAnalysis with payload #{payload} and attrs #{attrs}"
            pa = PendingAnalysis.
              create_with(attrs).
              find_or_create_by!(
                address_transaction: payload.fetch('address'),
                cc_code:             payload.fetch('cc_code'),
                source:              payload.fetch('source'),
                state:               :pending,
                reply_to:            metadata.reply_to,
                correlation_id:      metadata.correlation_id,
            )
            finded_attrs = pa.attributes.slice(*attrs.keys.map(&:to_s)).symbolize_keys
            unless finded_attrs.sort.join == attrs.sort.join
              report_exception 'Отличия в PendingAnalysis', true, { pending_analisis_id: pa.id, attr: attrs, finded_attrs: finded_attrs }
            end
          rescue ActiveRecord::RecordInvalid => err
            logger.info "PendingAnalysis already exists #{payload} with error #{err}"
          end
        end
      end
    end
  end
end
