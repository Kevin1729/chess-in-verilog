#include <iostream>
#include <string>
using namespace std;
int main()
{
    string yourString = "00c124080000000000000000000000000000010000000000040000000000100000080000000000004000000000000000000000000880630000000000000000000000000020000000000000040000000400000000000400000000000000000040";
    for (int i = yourString.length() - 16; i >= 0; i -= 16) {
        for (int j = i; j < i + 16; j++) {
            cout << yourString[j];
        }
    }
    cout << endl;
}