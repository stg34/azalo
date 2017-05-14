module AzPrototypeFormHelper
  def az_remote_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!

    case record_or_name_or_array
    when String, Symbol
      object_name = record_or_name_or_array
    when Array
      object = record_or_name_or_array.last
      object_name = ActionController::RecordIdentifier.singular_class_name(object)
      apply_form_for_options!(record_or_name_or_array, options)
      args.unshift object
    else
      object      = record_or_name_or_array
      object_name = ActionController::RecordIdentifier.singular_class_name(record_or_name_or_array)
      apply_form_for_options!(object, options)
      args.unshift object
    end

    concat(az_form_remote_tag(options))
    fields_for(object_name, *(args << options), &proc)
    concat('</form>'.html_safe)
  end
  alias_method :az_form_remote_for, :az_remote_form_for

  def az_form_remote_tag(options = {}, &block)
    options[:form] = true

    options[:success] =
      (options[:success] ? options[:success] + "; " : "") +
      "operation_finish(op_id, 'success')"

    options[:failure] =
      (options[:failure] ? options[:failure] + "; " : "") +
      "operation_finish(op_id, 'error')"

    options[:html] ||= {}
    options[:html][:onsubmit] =
      (options[:html][:onsubmit] ? options[:html][:onsubmit] + "; " : "") +
      "var op_id = operation_start('submit');#{remote_function(options)}; return false;"

    form_tag(options[:html].delete(:action) || url_for(options[:url]), options[:html], &block)
  end

  def az_link_to_remote(name, options = {}, html_options = nil)

    options[:success] =
      (options[:success] ? options[:success] + "; " : "") +
      "operation_finish(op_id, 'success')"

    options[:failure] =
      (options[:failure] ? options[:failure] + "; " : "") +
      "operation_finish(op_id, 'error')"

    options[:html] ||= {}
    options[:html][:onclick] =
      (options[:html][:onclick] ? options[:html][:onclick] + "; " : "") +
      "var op_id = operation_start('submit')"

    link_to_function(name, remote_function(options), html_options || options.delete(:html))
  end
end
