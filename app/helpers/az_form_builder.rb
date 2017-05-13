class AzFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    str = super
    self.field_holder(str, method, options)
  end

  def password_field(method, options = {})
    str = super
    self.field_holder(str, method, options)
  end

  def file_field(method, options = {})
    str = super
    self.field_holder(str, method, options)
  end

  def text_area(method, options = {})
    str = super
    self.field_holder(str, method, options)
  end

  def field_holder(content, method, options = {})
    error_class = self.error_message_on(method).empty? ? '' : 'error_description'

    @template.content_tag('table',
      @template.content_tag('tr',
        @template.content_tag('td', content) + @template.content_tag('td', self.error_message_on(method), :class => error_class)),
     :class => 'form-field-holder')
  end

  def submit(method, options = {})
    super
  end
end

