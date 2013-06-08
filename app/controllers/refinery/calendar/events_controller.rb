module Refinery
  module Calendar
    class EventsController < ::ApplicationController
      def index
        @events = Event.upcoming.order('refinery_calendar_events.starts_at DESC')

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @event in the line below:
        present(@page)
      end

      def show
        @event = Event.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @event in the line below:
        present(@page)
      end

      def archive
        @events = Event.archive.order('refinery_calendar_events.starts_at DESC')
        render :template => 'refinery/calendar/events/index'
      end

      def events_in_json
        params[:month] ||= Date.today.strftime("%m")
        params[:year] ||= Date.today.strftime("%Y")
        month = params[:month].to_i
        year = params[:year].to_i
        period_date = Date.new(year, month)

        @events = Event.where(:starts_at => period_date.beginning_of_month.beginning_of_day..period_date.end_of_month.end_of_day).order('refinery_calendar_events.starts_at ASC')
        respond_to do |format|
          format.json { render :json => @events.to_json }
        end
      end

      protected
      def find_page
        @page = ::Refinery::Page.where(:link_url => "/calendar/events").first
      end

    end
  end
end
