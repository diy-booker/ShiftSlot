class Show < ApplicationRecord
  validate :assign_venue
  belongs_to :venue
  has_many :shifts
  has_many :users, through: :shifts
  validates_presence_of :start, :info, :venue_id

  def date
    self.start.strftime('%A, %D')
  end

  def readable(time)
    return time.strftime('%I:%M%p') if time
    'time not set'
  end

  def assign_venue
    venue_abbreviation = nil
    Venue.abbreviations.each do |abbrev|
      if self.info
        venue_abbreviation = abbrev if self.info.include? abbrev
      end
    end
    return self.venue = Venue.find_by(abbreviation: venue_abbreviation) if venue_abbreviation
    return self.errors.add(:associated_venue, "ShiftSlot wasn't able to automatically infer the venue for the show on #{self.date || "this show"}. You should go back to the Google Calendar event and add one of the following to the summary and that should fix the problem: #{Venue.abbreviations.join(', ')}") if self.info
    return self.errors.add(:missing_date, "Shifslot couldn't find the date form google calendar.")
    self.errors.add(:info, "The info for this show has not been set.")
  end

  def day
    self.start.strftime('%A')
  end

  def staffed?
    return false if self.shifts.empty?
    self.shifts.each do |shift|
      return false if !shift.user_id
    end
    true
  end

  def start_time
    self.start
  end

  def already_working?(user)
    self.shifts.map{ |shift| shift.user_id }.include?(user.id)
  end

  def self.available_shifts_for(current_user)
    shows = Show.all.select { |show| !show.already_working?(current_user) }
    shifts = []
    shows.map do |show|
      shifts << show.shifts.select { |shift| current_user.authorized?(shift.job) && shift.user_id == nil }
    end
    shifts.flatten!
  end


end
