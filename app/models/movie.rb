class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G', 'PG-13', 'PG', 'R']
    end
end
