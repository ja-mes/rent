module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
      <div class="row form-errors" style="margin-bottom: 10px;">
        <div class="col-xs-8 ">
          <div class="card card-inverse card-danger">
            <div class="card-block">
              <h5 class="card-title">
                #{sentence}
              </h5>

              <ul class="card-text">
                #{messages}
              </ul>
            </div>
          </div>
        </div>
      </div>
    HTML

    html.html_safe
  end
end
