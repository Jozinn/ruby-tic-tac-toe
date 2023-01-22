class Board
    @fields = Array.new(9)
    @win_vectors = [[0,1,2], [3,4,5] [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    @curr_player_id = 0

    attr_accessor :fields, :players, :curr_player_id
    attr_reader :win_vectors

    def initialize(player1, player2)
        @players = [player1.new(self, 'X'), player2.new(self, 'O')]
    end

    def check_full?
        empty_fields = fields.select {|field| field == nil}
        if (empty_fields.length == 0)
            return true
        end
        return false
    end

    def check_winner?
        win_vectors.each do |vector|
            fields_to_check = [fields[vector[0]], fields[vector[1]], fields[vector[2]]]
            if (fields_to_check.any?(&:nil?))
                return false
            end

            if (fields_to_check[0] == fields_to_check[1] && fields_to_check[1] == fields_to_check[2])
                return true
            end

            return false
        end
    end

    def play
        loop do
            player_move(curr_player)
            if (check_winner?)
                puts "#{curr_player} wins!"
                printer
                return
            end

            if (check_full?)
                puts "Draw!"
                printer
                return
            end

            switch_players!
        end
    end

    def curr_player
        return players[curr_player_id]
    end

    def switch_players!
        other_player = 1 - curr_player_id
        self.curr_player_id = other_player
    end

    def player_move(player)
        position = player.move
        puts "#{player} puts #{player.marker} at position #{position}"
        self.fields[position] = player.marker
    end

    def printer
        col_separator = '|'
        row_separator = '-------'
        field_labels = fields.map.with_index {|position, i| fields[i] ? fields[i] : i}
        (0..2).each do |i|
            row = field_labels[i*3, 3]
            row.map! {|label| label.to_s + col_separator}
            row.unshift(col_separator)
            puts row
            puts row_separator if (i != 2)
        end
    end
end

class Player
    def initialize(game, marker)
        @game = game
        @marker = marker
    end

    attr_reader :marker

    def move
        loop do
            puts "select your #{marker} position"
            position = gets.to_i
            return position if (!game.fields[position])
            puts "Position unavailable, choose different field"
        end
    end
end

game = Board.new(Player, Player).play