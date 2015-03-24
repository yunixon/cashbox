RSpec::Matchers.define :have_inline_error do |expected|
  define_method :for_field do |field|
    @field = field
    self
  end

  define_method :for_field_name do |field_name|
    @field_name = field_name
    self
  end

  def options
    options = if @field
      [".form-group", text: @field]
    elsif @field_name
      selectors = [
        "descendant::input[@name='#{@field_name}']",
        "descendant::textarea[@name='#{@field_name}']",
        "descendant::select[@name='#{@field_name}']",
      ]
      xpath = %Q{//*[contains(@class,'form-group') and (#{selectors.join(' or ')})]}
      [:xpath, xpath]
    end
    options.join(',')
  end

  match do |page|
    within(options) do
      page.has_content?(expected)
    end
  end

  match_when_negated do |page|
    within(options) do
      page.has_no_content?(expected)
    end
  end

  failure_message do |page|
    %Q{expected to have inline error \"#{expected}\" for field \"#{@field || @field_name}\"}
  end

  failure_message_when_negated do |page|
    %Q{expected to not have inline error \"#{expected}\" for field \"#{@field || @field_name}\"}
  end

  description do
    %Q{have inline error \"#{expected}\" for field \"#{@field || @field_name}\"}
  end
end
