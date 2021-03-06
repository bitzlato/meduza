class ActiveModel::Name
  def human_plural(options = {})
    return @human_plural unless @klass.respond_to?(:lookup_ancestors) &&
      @klass.respond_to?(:i18n_scope)

    defaults = @klass.lookup_ancestors.map do |klass|
      klass.model_name.i18n_key
    end

    defaults << options[:default] if options[:default]
    defaults << @human_plural

    options = { scope: [@klass.i18n_scope, :models], count: 100, default: defaults }.merge!(options.except(:default))
    I18n.translate(defaults.shift, **options)
  end
end
