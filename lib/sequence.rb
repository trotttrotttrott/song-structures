class Sequence

  attr_reader :events, :io

  def initialize
    @events = []
  end

  def <<(event)
    @events << event
  end

  def write!(io)

    @io = io

    # header chunk
    io.print "MThd"
    write32 6   # length
    write16 0   # format
    write16 1   # tracks
    write16 248 # division

    # track chunk
    io.print "MTrk"
    write32 events.flatten.size
    events.flatten.each do |byte|
      io.putc byte
    end

    io.close
  end

  private

  def write16(val)
    val = (-val | 0x8000) if val < 0
    io.putc((val >> 8) & 0xff)
    io.putc(val & 0xff)
  end

  def write32(val)
    val = (-val | 0x80000000) if val < 0
    io.putc((val >> 24) & 0xff)
    io.putc((val >> 16) & 0xff)
    io.putc((val >> 8) & 0xff)
    io.putc(val & 0xff)
  end
end
