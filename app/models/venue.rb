class Venue < ApplicationRecord
  validates_presence_of :name, :location
  validates_uniqueness_of :name, scope: :location, message: "There is already a venue with that name in that location"
  has_many :shows, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :partnerships
  has_many :organizations, through: :partnerships
  after_create :seed_jobs

  def parsed_hooks
    return self.hooks.split(',') if self.hooks
    nil
  end

  protected

  def seed_jobs
    self.jobs << Job.create(title: 'volunteer')
  end
end
