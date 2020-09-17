# frozen_string_literal: true

module Promotion
  def promotion?(trg)
    (trg.is_a?(Pawn) && trg.rank == 0 && trg.color == 'white') ||
      (trg.is_a?(Pawn) && trg.rank == 7 && trg.color == 'black')
  end

  def promote(trg)
    print display_promotion_prompt
    input = gets.chomp.upcase
    until input.match?(/^[bnrq]$/i)
      print display_promotion_prompt
      input = gets.chomp.upcase
    end
    new_piece = transform(input, trg)
    place(new_piece)
  end

  def transform(input, trg)
    case input
    when 'B'
      transform_to_bishop(trg)
    when 'N'
      transform_to_knight(trg)
    when 'R'
      transform_to_rook(trg)
    when 'Q'
      transform_to_queen(trg)
    end
  end

  def transform_to_bishop(trg)
    Bishop.new(trg.file, trg.rank, trg.color)
  end

  def transform_to_knight(trg)
    Knight.new(trg.file, trg.rank, trg.color)
  end

  def transform_to_rook(trg)
    Rook.new(trg.file, trg.rank, trg.color)
  end

  def transform_to_queen(trg)
    Queen.new(trg.file, trg.rank, trg.color)
  end
end
