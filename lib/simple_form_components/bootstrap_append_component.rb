module InputGroupAppendComponent
  # To avoid deprecation warning, you need to make the wrapper_options explicit
  # even when they won't be used.
  def input_group_append(wrapper_options = nil)
    @input_group_append ||= begin
      options[:append].to_s.html_safe if options[:append].present?
    end
  end
end

SimpleForm.include_component(InputGroupAppendComponent)