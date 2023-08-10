#include "utility.h"
#include "masks.h"
#include "types.h"
#include <cctype>
#include <iostream>
using namespace std;
bitboardList_t stringToBitboards(stringboard_t stringBoard)
{
    bitboardList_t bitboardList = { 0, 0, 0, 0, 0, 0, 0, 0 };
    for (int i = 7; i >= 0; i--) {
        int rank = 8 - i;
        for (int j = 0; j < 8; j++) {
            int file = j + 1;
            char piece = stringBoard[i][j];
            switch (piece) {
            case 'p':
                bitboardList[BLACK_PAWN].set(file, rank);
                break;
            case 'n':
                bitboardList[BLACK_KNIGHT].set(file, rank);
                break;
            case 'b':
                bitboardList[BLACK_BISHOP].set(file, rank);
                break;
            case 'r':
                bitboardList[BLACK_ROOK].set(file, rank);
                break;
            case 'q':
                bitboardList[BLACK_QUEEN].set(file, rank);
                break;
            case 'k':
                bitboardList[BLACK_KING].set(file, rank);
                break;
            case 'P':
                bitboardList[WHITE_PAWN].set(file, rank);
                break;
            case 'N':
                bitboardList[WHITE_KNIGHT].set(file, rank);
                break;
            case 'B':
                bitboardList[WHITE_BISHOP].set(file, rank);
                break;
            case 'R':
                bitboardList[WHITE_ROOK].set(file, rank);
                break;
            case 'Q':
                bitboardList[WHITE_QUEEN].set(file, rank);
                break;
            case 'K':
                bitboardList[WHITE_KING].set(file, rank);
                break;
            default:
                break;
            }
        }
    }
    return bitboardList;
}
bitboardList_t fen(string fenstring)
{
    stringboard_t stringboard;
    int file = a - 1;
    for (char c : fenstring) {

        if (isdigit(c)) {
            for (int i = 0; i < c - '0'; i++) {
                stringboard[file] += '.';
            }
        } else if (c == '/') {
            file++;
        } else if (c == ' ') {
            break;
        } else {
            stringboard[file] += c;
        }
    }
    for (string s : stringboard) {
        cout << s << endl;
    }
    return stringToBitboards(stringboard);
}
bool bitboard::get(int file, int rank)
{
    rank--;
    file--;
    return !!(bits & (1ull << (rank * 8 + file)));
}
void bitboard::set(int file, int rank)
{
    rank--;
    file--;
    bits |= (1ull << (rank * 8 + file));
}
void bitboard::reset(int file, int rank)
{
    rank--;
    file--;
    bits &= ~(1ull << (rank * 8 + file));
}
bitboard_t rookAttackRay(bitboard_t occBits, bitboard_t rook, bitboard_t mask)
{
    bitboard_t occ = occBits & mask;
    return (occBits ^ (occ - 2 * rook)) & mask;
}
bitboard bitboard::rookAttack(int file, int rank)
{
    bitboard rook = { 0 };
    rook.set(file, rank);
    bitboard_t maskVertical = 0x0101010101010101ull * (1ull << (file - 1));
    bitboard_t maskHorizontal = 0xFFull << (8 * (rank - 1));
    bitboard maskBBVertical = { maskVertical };
    bitboard maskBBHorizontal = { maskHorizontal };

    // calculate up ray
    bitboard up = { rookAttackRay(bits, rook.bits, maskVertical) };

    // calculate left ray
    bitboard left = { rookAttackRay(rotateCW().bits, rook.rotateCW().bits, maskBBHorizontal.rotateCW().bits) };
    left = left.rotateCCW();

    // calculate right ray
    bitboard right = { rookAttackRay(rotateCCW().bits, rook.rotateCCW().bits, maskBBHorizontal.rotateCCW().bits) };
    right = right.rotateCW();

    // calculate down ray
    bitboard down = { rookAttackRay(flipVertical().bits, rook.flipVertical().bits, maskBBVertical.bits) };
    down = down.flipVertical();

    return { up.bits | left.bits | right.bits | down.bits };
}
bitboard bitboard::flipVertical()
{
    bitboard_t bitsCopy = bits;
    const bitboard_t k1 = (0x00FF00FF00FF00FFull);
    const bitboard_t k2 = (0x0000FFFF0000FFFFull);
    bitsCopy = ((bitsCopy >> 8) & k1) | ((bitsCopy & k1) << 8);
    bitsCopy = ((bitsCopy >> 16) & k2) | ((bitsCopy & k2) << 16);
    bitsCopy = (bitsCopy >> 32) | (bitsCopy << 32);
    return { bitsCopy };
}
bitboard bitboard::flipHorizontal()
{
    bitboard_t bitsCopy = bits;
    const bitboard_t k1 = (0x5555555555555555ull);
    const bitboard_t k2 = (0x3333333333333333ull);
    const bitboard_t k4 = (0x0f0f0f0f0f0f0f0full);
    bitsCopy = ((bitsCopy >> 1) & k1) | ((bitsCopy & k1) << 1);
    bitsCopy = ((bitsCopy >> 2) & k2) | ((bitsCopy & k2) << 2);
    bitsCopy = ((bitsCopy >> 4) & k4) | ((bitsCopy & k4) << 4);
    return { bitsCopy };
}
bitboard bitboard::flipDiagonal()
{
    bitboard_t bitsCopy = bits;
    bitboard_t t;
    const bitboard_t k1 = (0x5500550055005500ull);
    const bitboard_t k2 = (0x3333000033330000ull);
    const bitboard_t k4 = (0x0f0f0f0f00000000ull);
    t = k4 & (bitsCopy ^ (bitsCopy << 28));
    bitsCopy ^= t ^ (t >> 28);
    t = k2 & (bitsCopy ^ (bitsCopy << 14));
    bitsCopy ^= t ^ (t >> 14);
    t = k1 & (bitsCopy ^ (bitsCopy << 7));
    bitsCopy ^= t ^ (t >> 7);
    return { bitsCopy };
}
bitboard bitboard::flipAntiDiagonal()
{
    bitboard_t bitsCopy = bits;
    bitboard_t t;
    const bitboard_t k1 = (0xaa00aa00aa00aa00ull);
    const bitboard_t k2 = (0xcccc0000cccc0000ull);
    const bitboard_t k4 = (0xf0f0f0f00f0f0f0full);
    t = bitsCopy ^ (bitsCopy << 36);
    bitsCopy ^= k4 & (t ^ (bitsCopy >> 36));
    t = k2 & (bitsCopy ^ (bitsCopy << 18));
    bitsCopy ^= t ^ (t >> 18);
    t = k1 & (bitsCopy ^ (bitsCopy << 9));
    bitsCopy ^= t ^ (t >> 9);
    return { bitsCopy };
}
bitboard bitboard::rotateCW()
{
    return flipVertical().flipAntiDiagonal();
}
bitboard bitboard::rotateCCW()
{
    return flipVertical().flipDiagonal();
}
bitboard diagonalAttack(bitboard_t bits, int file, int rank)
{
    bitboard bitMask = { 0 };
    bitMask.set(file, rank);
    bitboard forward = { 0 };
    bitboard reverse = { 0 };
    forward.bits = bits & diagonalMasks[file - rank];
    reverse = forward.flipVertical();
    forward.bits -= bitMask.bits;
    reverse.bits -= bitMask.flipVertical().bits;
    forward.bits ^= reverse.flipVertical().bits;
    forward.bits &= diagonalMasks[file - rank];
    return forward;
}
bitboard antidiagonalAttack(bitboard_t bits, int file, int rank)
{
    bitboard bitMask = { 0 };
    bitMask.set(file, rank);
    bitboard forward = { 0 };
    bitboard reverse = { 0 };
    forward.bits = bits & antidiagonalMasks[file + rank];
    reverse = forward.flipVertical();
    forward.bits -= bitMask.bits;
    reverse.bits -= bitMask.flipVertical().bits;
    forward.bits ^= reverse.flipVertical().bits;
    forward.bits &= antidiagonalMasks[file + rank];
    return forward;
}
bitboard bitboard::bishopAttack(int file, int rank)
{
    return { diagonalAttack(bits, file, rank).bits | antidiagonalAttack(bits, file, rank).bits };
}
bitboard bitboard::queenAttack(int file, int rank)
{
    return { bishopAttack(file, rank).bits | rookAttack(file, rank).bits };
}

bitboard bitboard::whitePawnSetAttack()
{
    return { (bits << 9 & ~fileMasks[a]) | (bits << 7 & ~fileMasks[h]) };
}

bitboard bitboard::blackPawnSetAttack()
{
    return { (bits >> 7 & ~fileMasks[a]) | (bits >> 9 & ~fileMasks[h]) };
}
bitboard bitboard::fileAttack(int file, int rank)
{
    bitboard forward, reverse;
    bitboard rook;
    rook.set(file, rank);
    forward.bits = bits & fileMasks[file];
    reverse.bits = forward.flipVertical().bits;
    forward.bits -= rook.bits;
    reverse.bits -= rook.flipVertical().bits;
    forward.bits ^= reverse.flipVertical().bits;
    forward.bits &= fileMasks[file];
    return { forward };
}
void bitboard::print()
{
    for (int rank = 8; rank >= 1; rank--) {
        for (int file = a; file <= h; file++) {
            cout << get(file, rank);
        }
        cout << endl;
    }
}

bitboard positionBitboard(bitboardList_t list)
{
    bitboard_t positions = 0ull;
    for (auto piece : list) {
        positions |= piece.bits;
    }
    return { positions };
}

bitboard positionWhiteBitboard(bitboardList_t list)
{
    bitboard_t positions = 0ull;
    for (int i = WHITE_PAWN; i <= WHITE_KING; i++)
        positions |= list[i].bits;
    return { positions };
}