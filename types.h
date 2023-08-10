#ifndef TYPES_H_
#define TYPES_H_
#include <array>
#include <cstdint>
#include <vector>

using bitboard_t = std::uint64_t;
struct bitboard {
    bitboard_t bits;
    bool get(int file, int rank);
    void set(int file, int rank);
    void reset(int file, int rank);
    bitboard flipVertical();
    bitboard flipHorizontal();
    bitboard flipDiagonal();
    bitboard flipAntiDiagonal();
    bitboard rotateCW();
    bitboard rotateCCW();
    bitboard rookAttack(int file, int rank);
    bitboard bishopAttack(int file, int rank);
    bitboard queenAttack(int file, int rank);
    bitboard whitePawnSetAttack();
    bitboard blackPawnSetAttack();
    bitboard fileAttack(int file, int rank);
    void print();
};

using stringboard_t = std::array<std::string, 8>;
using bitboardList_t = std::array<bitboard, 12>;

#endif // TYPES_H_