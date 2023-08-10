#ifndef MASKS_H_
#define MASKS_H_

#include "types.h"
#include <cstdint>

static bitboard_t diagonalMasksRAW[15] = {
    0x100000000000000ull,
    0x201000000000000ull,
    0x402010000000000ull,
    0x804020100000000ull,
    0x1008040201000000ull,
    0x2010080402010000ull,
    0x4020100804020100ull,
    0x8040201008040201ull,
    0x80402010080402ull,
    0x804020100804ull,
    0x8040201008ull,
    0x80402010ull,
    0x804020ull,
    0x8040ull,
    0x80ull,
};
static bitboard_t antidiagonalMasksRAW[15] = {
    0x1ull,
    0x102ull,
    0x10204ull,
    0x1020408ull,
    0x102040810ull,
    0x10204081020ull,
    0x1020408102040ull,
    0x102040810204080ull,
    0x204081020408000ull,
    0x408102040800000ull,
    0x810204080000000ull,
    0x1020408000000000ull,
    0x2040800000000000ull,
    0x4080000000000000ull,
    0x8000000000000000ull,
};

static bitboard_t rankMasksRAW[8] = {
    0xFFull,
    0xFF00ull,
    0xFF0000ull,
    0xFF000000ull,
    0xFF00000000ull,
    0xFF0000000000ull,
    0xFF000000000000ull,
    0xFF00000000000000ull,
};
static bitboard_t fileMasksRAW[8] = {
    0x0101010101010101ull,
    0x0202020202020202ull,
    0x0404040404040404ull,
    0x0808080808080808ull,
    0x1010101010101010ull,
    0x2020202020202020ull,
    0x4040404040404040ull,
    0x8080808080808080ull,
};
static bitboard_t* fileMasks = fileMasksRAW - 1;
static bitboard_t* rankMasks
    = rankMasksRAW - 1;
static bitboard_t* diagonalMasks
    = diagonalMasksRAW + 7;
static bitboard_t* antidiagonalMasks = antidiagonalMasksRAW - 2;

#endif // MASKS_H_