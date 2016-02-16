class Movie < ActiveRecord::Base
    def self.rating
        return ['G','PG','PG-13','R']
    end
end