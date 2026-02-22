#include <iostream>
#include <vector>
#include <limits>
#include <string>

// Безопасный ввод целого числа
bool safeInputInt(int &value) {
    std::cin >> value;

    if (std::cin.fail()) {
        std::cin.clear(); 
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        return false;
    }

    return true;
}

int main() {
    int N;

    // ===== Ввод размера матрицы =====
    while (true) {
        std::cerr << "Enter matrix size N (1..1000): ";

        if (!safeInputInt(N)) {
            std::cerr << "Invalid input. Please enter an integer.\n";
            continue;
        }

        if (N <= 0 || N > 1000) {
            std::cerr << "N must be between 1 and 1000.\n";
            continue;
        }

        break;
    }

    std::vector<std::vector<int>> matrix(N, std::vector<int>(N));

    std::cerr << "Enter matrix elements:\n";

    // ===== Ввод элементов матрицы =====
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            while (true) {
                std::cerr << "Element [" << i << "][" << j << "]: ";

                if (!safeInputInt(matrix[i][j])) {
                    std::cerr << "Invalid input. Please enter an integer.\n";
                    continue;
                }

                break;
            }
        }
    }

    // ===== Поиск минимального элемента на диагоналях =====
    int minValue = std::numeric_limits<int>::max();

    for (int i = 0; i < N; ++i) {
        // Главная диагональ
        if (matrix[i][i] < minValue)
            minValue = matrix[i][i];

        // Побочная диагональ
        if (matrix[i][N - 1 - i] < minValue)
            minValue = matrix[i][N - 1 - i];
    }

    // ===== Замена элементов выше главной диагонали =====
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            if (i < j) {
                matrix[i][j] = minValue;
            }
        }
    }

    // ===== Вывод результата =====
    std::cerr << "\nResult matrix:\n";
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            std::cout << matrix[i][j] << " ";
        }
        std::cout << "\n";
    }

    return 0;
}