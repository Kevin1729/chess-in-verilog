#include "masks.h"
#include "types.h"
#include "utility.h"
#include <iomanip>
#include <iostream>
using namespace std;

int main()
{
    stringboard_t stringboard = {
        "rnbqkbnr",
        "pppppppp",
        "........",
        "........",
        "........",
        "........",
        "PPPPPPPP",
        "RNBQKBNR",
    };
    stringboard_t Rboard = {
        ".pppp...",
        ".p...p..",
        ".p...p..",
        ".p..p...",
        ".ppp....",
        ".p.p....",
        ".p..p...",
        ".p...p..",
    };
    stringboard_t mask = {
        "pB...KQR",
        "npB...KQ",
        "bnpB...K",
        "rbnpB...",
        "qrbnpB..",
        "kqrbnpB.",
        "PkqrbnpB",
        "NPkqrbnp",
    };
    bitboardList_t fenboards = fen("2bq1rk1/3n1pb1/6p1/p2p3p/Pppp1P1N/4P1Q1/BPP1N1P1/R3K2R b - - 2 23");
    bitboardList_t bitboardList
        = stringToBitboards(stringboard);
    // bitboardList[BLACK_PAWN].print();
    bitboardList_t maskList = stringToBitboards(mask);
    cout << "HELLO\n";
    for (int i = WHITE_KING; i >= BLACK_PAWN; i--) {

        cout << setw(16) << setfill('0') << hex << bitboardList[i].bits;
    }
    cout << "------\n";
    char file = 'f';
    int rank = 2;

    int piece = WHITE_KING;
    // maskList[piece].print();
    cout << "------\n";
    // for (int i = WHITE_KING; i >= WHITE_ROOK; i--) {
    //     cout << hex << maskList[i].bits << endl;
    // }
    // cout << hex << maskList[piece].bits << endl;
    //  bitboard diagA2 = { diagonalMasks[a - 2] };

    //    for (int i = a; i <= h; i++) {
    //       bitboard file = { fileMasks[i] };
    //      file.print();
    //     cout << "--------\n";
    // }

    bitboard position = positionBitboard(bitboardList);
    bitboard zeroes = { 0 };
    // zeroes.rookAttack(e, 5).print();
    //  zeroes.queenAttack(b, 3).print();
    //  bitboardList[BLACK_KNIGHT].print();
    /*    fenboards[BLACK_KNIGHT].print();
       for (int i = BLACK_PAWN; i <= WHITE_KING; i++) {
           cout << "64'h" << hex << fenboards[i].bits << endl;
       } */
    // cout << "769'h";
    for (int i = 11; i >= 0; i--) {
        bitboard board = fenboards[i];
        cout << hex << setfill('0') << setw(16) << board.bits;
        // cout << "--------\n";
    }
    // cout << "----------\n";
    // cout << hex << positionBitboard(fenboards).bits << endl;
    // positionBitboard(fenboards).print();
    // cout << "------------\n";
    // positionWhiteBitboard(fenboards).print();
    // cout << hex << positionWhiteBitboard(fenboards).bits << endl;
    // cout << "-----------\n";
    // positionBitboard(fenboards).rookAttack(e, 4).print();
    // cout << hex << positionBitboard(fenboards).rookAttack(e, 4).bits << endl;
    // cout << hex << positionBitboard(fenboards).bishopAttack(e, 4).bits << endl;
    // positionBitboard(fenboards).bishopAttack(e, 4).print();
}