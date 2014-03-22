class NoteTestHelper
  def self.new_note(value)
    Note.new(value, Note.accidental_required?(value) ? :sharp :nil)
  end
end
