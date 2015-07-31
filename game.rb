class Game
  attr_accessor :player_circle, :names, :picker

  # Setup the basic circle so the players can begin the game.
  def initialize names
    @names = names
    @names.shuffle!

    @player_circle = PlayerCircle.new

    @names.each do |name|
      @player_circle.add Player.new name
    end
  end

  # Play a round of the game.
  def play_round
    @picker = @player_circle.select_random_player

    @picker.save_circle = @player_circle.clone

    goose = @picker.walk_circle

    Announce.chase goose, @picker

    picker_caught = goose.chase
    if !picker_caught      
      @picker = Picker.new goose.name 
      Announce.new_picker @picker
    end
  end  
end

# Announces game events.
class Announce
  def self.chase player_a, player_b
    puts player_a.name + " now chases " + player_b.name + "!"
  end

  def self.new_picker player
     player.name + " is now the picker!"
  end
end

# Models both the actual player circle and the player's concept of a player circle.
class PlayerCircle
  attr_accessor :players, :full_list

  def size
    @players.size
  end

  def reset
    @players = @full_list
  end

  def empty
    @players.size == 0
  end

  def clone
    copy = PlayerCircle.new
    copy.players = Array.new @players
    copy 
  end

  def pop
    players.pop
  end

  def add
    @players.append player
    @full_list.append player
  end

  # Returns a random player from the list, no removal.
  def self.select_random_player
    generator = Random.new
    random_number = generator.rand(@players.size) 
    @players[random_number]
  end
end

class Player
  attr_accessor :name, :speed

  def initialize name
    @name = name
    @speed = (1..10).to_a.sample
  end

  def self.quack
    #puts self.class.to_s
  end
end

class Picker < Player
  attr_accessor :chosen_goose, :speed

  def save_circle
  end

  def choose_goose
  end

  def dub player, chosen_goose, count, minimum_walk    
    if (player.name == chosen_goose.name) && (minimum_walk < count)
      label = "goose" 
    else
      label = "duck"
    end

    statement = player.name + " says " + label + " to " + player.name
  end

  def generate_minimum_walk circle
    generator = Random.new
    #range = circle.size / 2 .. circle.size * 2
    range = 10 # @fixme
    random_walk = generator.rand(range) 
  end

  def walk_circle circle
    chosen_goose = circle.select_random_player
    minimum_walk = generate_minimum_walk circle

    minimum_walk.times do |count|
      if !circle.empty
        dub circle.pop, chosen_goose, count, minimum_walk
      else
        circle.reset
      end
    end
    goose
  end
end

class Duck < Player
end

class Goose < Player
  def chase picker
    @speed > picker.speed
  end
end

#the_game = Game.new ["Chris", "Shane", "Justin", "Luke", "Paulina", "David", "Ian", "Leigh", "Mattie", "Brice"]

#5.times do 
 # the_game.play_round
#end

Goose.quack