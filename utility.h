#ifndef UTILITY_H_
#define UTILITY_H_
#include "types.h"
#include <array>
#include <cstdint>
#include <string>
#include <vector>
constexpr int a = 1;
constexpr int b = 2;
constexpr int c = 3;
constexpr int d = 4;
constexpr int e = 5;
constexpr int f = 6;
constexpr int g = 7;
constexpr int h = 8;
constexpr int BLACK_PAWN = 0;
constexpr int BLACK_KNIGHT = 1;
constexpr int BLACK_BISHOP = 2;
constexpr int BLACK_ROOK = 3;
constexpr int BLACK_QUEEN = 4;
constexpr int BLACK_KING = 5;
constexpr int WHITE_PAWN = 6;
constexpr int WHITE_KNIGHT = 7;
constexpr int WHITE_BISHOP = 8;
constexpr int WHITE_ROOK = 9;
constexpr int WHITE_QUEEN = 10;
constexpr int WHITE_KING = 11;
constexpr char SYMBOL[] = { 'p', 'n', 'b', 'r', 'q', 'k', 'P', 'N', 'B', 'R', 'Q', 'K' };

bitboardList_t stringToBitboards(stringboard_t stringBoard);
bitboardList_t fen(std::string fenstring);
bitboard positionBitboard(bitboardList_t list);

bitboard positionWhiteBitboard(bitboardList_t list);
#endif // UTILITY_H_