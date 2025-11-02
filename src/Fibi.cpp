#include <iostream>
#include <cstdlib> // Для использования atoi

using namespace std;

long long fibonacchi(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;

    long long a = 0, b = 1, temp;
    for (int i = 2; i <= n; ++i) {
        temp = a + b;
        a = b;
        b = temp;
    }
    return b;
}

int main(int argc, char* argv[]) {
    int n;

    if (argc == 2) {
        
        n = atoi(argv[1]); 
    } else {
       
        cout << "Enter the number of Fibonacci: ";
        while(true) {
            if(!(cin >> n)) {
                cout << "Error: enter the number! \n";
                cin.clear();
                cin.ignore(10000000, '\n');
                continue;
            }
            if(n < 1 || n >= 100) {
                cout << "Error: number should be 1 - 99!\n";
                continue; 
            }
            break;
        }
    }

    cout << "Number of Fibonacci #" << n << " = " << fibonacchi(n) << endl;

    return 0;
}