module RiskLevelsHelper
  RISK_LEVELS = {
    1 => { title: 'Safe', css_class: 'badge-success' },
    2 => { title: 'Suspicious', css_class: 'badge-warning' },
    3 => { title: 'Dangerous', css_class: 'badge-danger' }
  }.freeze

  def present_risk_level(risk_level)
    rl = RISK_LEVELS[risk_level]
    content_tag :span, rl.fetch(:title), class: ['badge', rl.fetch(:css_class)].join(' '), title: "risk_level=#{risk_level}"
  end

  def present_risk_confidence(risk_confidence)
    risk_confidence = (risk_confidence * 100).to_i
    content_tag :div, class: 'progress' do
      content_tag :div, "#{risk_confidence}%", style: "width: #{risk_confidence}%", class: "progress-bar", role: "progressbar", 'aria-valuenow' => risk_confidence, 'aria-valuemin' => 0,
                                               'aria-valuemax' => 100
    end
  end
end
