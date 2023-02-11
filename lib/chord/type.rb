# frozen_string_literal: true

Dir[File.dirname(__FILE__) + '/type/*.rb'].each { |file| require file.sub(/.rb\z/,'') }

class Chord::Type
  class << self; attr_reader :all_inversions end
  @all_inversions = [:root, :first, :second, :third]

  class << self
    def inversions
       Chord::Type.all_inversions[0..norm_interval_structure.size-1]
    end

    def all
      Chord::Type.constants.select {|c| Chord::Type.const_get(c).is_a? Class}
    end

    def create(chord_type)
      Object.const_get('Chord').
        const_get('Type').
        const_get("#{Chord::Type.all.select { |c| c.downcase == chord_type}.first}")
    end
  end
end
