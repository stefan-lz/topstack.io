require 'topstack/serel'

class TopStackParamsError < StandardError; end

class AbsorbController < ApplicationController

  def index
    begin
      @top, @tags, @time_range = get_params
    rescue TopStackParamsError => e
      return render_404
    end

    session['current_path'] = request.path
    @question_pool = serel_select({ top: @top, tags: @tags}.merge(@time_range))
    @absorb = current_user(create_guest: true).next_absorb!(@question_pool)

    if @absorb
      respond_to do |format|
        format.html { render action: 'show' } if @absorb
      end
    else
      @next_review_time = current_user.next_review_time(@question_pool)
      respond_to do |format|
        format.html { render action: 'no_results' } unless @absorb
      end
    end
  end

  def show
    @absorb = current_user.absorbs.find(params[:id])

    respond_to do |format|
      format.html { render action: 'show' }
    end
  end

  def update
    @absorb = current_user.absorbs.find(params[:id])
    @absorb.score = params[:score].to_i
    @absorb.answer_revealed_at = Time.at(params[:answer_revealed_at].to_i)
    @absorb.scored_at = Time.now
    @absorb.save

    @absorb.learning_box.next_level @absorb.score

    respond_to do |format|
      format.html { redirect_to session['current_path'] } if session['current_path']

      #if the session is lost, take the user home.
      format.html { redirect_to root_path } unless session['current_path']
    end
  end

  private

  def get_params
    if params[:top]
      top = top(params[:top])
      raise TopStackParamsError if !top
    else
      top = nil
    end

    if params[:tags]
      tags = tags(params[:tags])
      raise TopStackParamsError if tags.empty?
    else
      tags = []
    end

    if params[:time_range]
      time_range = time_range(params[:time_range])
      raise TopStackParamsError if time_range.keys.empty?
    else
      time_range = {}
    end

    if params[:unknown_filter]
      tags = tags(params[:unknown_filter])
      time_range = time_range(params[:unknown_filter]) if tags.empty?
      raise TopStackParamsError if tags.empty? && time_range.keys.empty?
    end

    return top, tags, time_range
  end

  def top top_param
    {'top-10' => 10,
     'top-50' => 50,
     'top-100' => 100}[top_param]
  end

  def tags tags_param
    ::TopStack::Serel.instance.tags.map{|t| t['name']} & tags_param.split('+')
  end

  def time_range time_range_param
    if time_range_param == 'this-week'
      { time_from: (DateTime.now.in_time_zone.beginning_of_day - 7.days).to_i,
        time_to: DateTime.now.in_time_zone.beginning_of_day.to_i}
    elsif time_range_param == 'this-month'
      { time_from: (DateTime.now.in_time_zone.beginning_of_day - 31.days).to_i,
        time_to: DateTime.now.in_time_zone.beginning_of_day.to_i }
    else
      return {}
    end
  end

  def serel_select filter_options
    ::TopStack::Serel.instance.questions filter_options
  end
end
