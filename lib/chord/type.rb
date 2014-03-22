Dir[File.dirname(__FILE__) + "/type/*.rb"].each { |file| require file.sub(/.rb\z/,'') }

class Chord::Type
  def self.create(chord_type)
    case chord_type
    when :maj7
      Chord::Type::Maj7
    when :seventh
      Chord::Type::Seventh
    when :minor7
      Chord::Type::Min7
    when :halfdim
      Chord::Type::HalfDim
    when :dim7
      Chord::Type::Dim7
    end
  end
end
