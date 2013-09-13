module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    has_many  :questions
    validates :name, :presence => true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :user_id
    end
  end

  scope :of_user, lambda{|user_id| { where(:user_id => user_id) }
end
