require 'topstack/serel'

module NavHelper
  def tags
    ::TopStack::Serel.instance.tags
  end

  def build_path options
    top = "top-#{options[:top] || @top || 10}"

    tags = options[:tags] || @tags
    if tags == 'nil' || tags.nil? || tags.empty?
      tags = nil
    else
      tags = tags.join('+')
    end

    time_range = options[:time_range] || humanized_time_range
    if time_range == 'nil'
      time_range = nil
    end

    '/' + [top, tags, time_range].compact.join('/')
  end

  def humanized_tags
    @tags.join(',') unless @tags.nil? || @tags.empty?
  end

  def humanized_time_range
    @human_readable_time_range ||=
      begin
        if @time_range.nil? || @time_range.keys.empty?
          nil
        elsif (@time_range[:time_to] - @time_range[:time_from]) == 7.days.to_i
          'this-week'
        elsif (@time_range[:time_to] - @time_range[:time_from]) == 31.days.to_i
          'this-month'
        end
      end
  end
end
