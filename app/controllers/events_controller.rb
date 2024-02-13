# app/controllers/events_controller.rb
class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
	  # Create or update user in Iterable
    iterable_response = IterableService.create_or_update_user(current_user)
    
    # Fetch events for display
    @events_a = Event.where(title: 'EventA')
    @events_b = Event.where(title: 'EventB')
  end

  # Create EventA and track the event in Iterable

  def create_event_a
    event = current_user.events.create(title: 'EventA', description: 'Description for EventA')
    iterable_response = IterableService.track_event(event, current_user.email)
    handle_iterable_response(iterable_response)
    redirect_to root_path
  end

  # Create EventB and track the event in Iterable

  def create_event_b
    event = current_user.events.create(title: 'EventB', description: 'Description for EventB')
    iterable_response = IterableService.track_event(event, current_user.email)
		handle_iterable_response(iterable_response)

    # Check if Event B has an associated email before attempting to send
    if current_user.email.present?
      email_response = send_email_notification(event, current_user)
      handle_email_response(email_response)
    else
      flash[:alert] = 'No associated email for EventB.'
    end
    redirect_to root_path
  end

  private

  # Private: Send targeted email notification using IterableService

  def send_email_notification(event, user)
    IterableService.send_email_target(user)
  end

  # Private: Handle iterable_response and display appropriate messages

  def handle_iterable_response(iterable_response)
    if iterable_response.key?('error')
      flash[:alert] = "Iterable Error: #{iterable_response['error']}"
    else
      flash[:notice] = 'Iterable request successful!'
    end
  end

  # Private: Handle email_response and display appropriate messages
 
  def handle_email_response(email_response)
    # Assuming email_response follows a similar structure as iterable_response
    if email_response.key?('error')
      flash[:alert] = "Email Error: #{email_response['error']}"
    else
      flash[:notice] = 'Email sent successfully!'
    end
  end

end
