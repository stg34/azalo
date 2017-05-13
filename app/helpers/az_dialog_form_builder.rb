class AzDialogFormBuilder < AzFormBuilder
#  def text_field(method, options = {})
#    str = super
#    self.field_holder(str, method, options)
#  end
#
#  def password_field(method, options = {})
#    str = super
#    self.field_holder(str, method, options)
#  end
#
#  def file_field(method, options = {})
#    str = super
#    self.field_holder(str, method, options)
#  end
#
#  def text_area(method, options = {})
#    str = super
#    self.field_holder(str, method, options)
#  end

  def field_holder(content, method, options = {})
    # errors_present = !self.error_message_on(method).empty?
    errors_present = self.object.errors.any?
    error_class = errors_present ? 'dialog_error_description' : ''

    if errors_present
      rnd = Integer(rand()*100000000).to_s
      message = @template.content_tag('div', self.object.errors(method), :id => "validate-message-content-#{rnd}")
      message_container = @template.content_tag('div', message, :style=>'display: none')
      img = @template.image_tag('/images/error_help.png', :id => "validate-message-#{rnd}", :class => "help-image")
      script = "<script>TooltipManager.addHTML('validate-message-#{rnd}', 'validate-message-content-#{rnd}');</script>"
    else
      img = ""
      message_container = ""
      script = ""
    end

    @template.content_tag('table',
      @template.content_tag('tr',
        @template.content_tag('td', content) + @template.content_tag('td', img + message_container + script, :class => error_class)),
     :class => 'form-field-holder')
  end

  def submit(method, options = {})
    super
  end
end

