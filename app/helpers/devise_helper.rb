module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
      <div class="row">
        <div class="col-xs-8 ">
          <div class="panel panel-danger">
            <div class="panel-heading">
              <h2 class="panel-title">
                #{sentence}
              </h2>

              <div class="panel-body">
                <ul>
                  #{messages}
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    HTML

    html.html_safe
  end
end
