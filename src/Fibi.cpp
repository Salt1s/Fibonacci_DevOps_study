#include <iostream>
#include <cstdlib>
#include <chrono>
#include <thread>
#include <prometheus/exposer.h>
#include <prometheus/registry.h>
#include <prometheus/counter.h>
#include <prometheus/histogram.h>

using namespace std;
using namespace prometheus;

long long fibonacci(int n) {
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
    Exposer exposer{"0.0.0.0:8080"};
    auto registry = std::make_shared<Registry>();

    std::vector<double> bucket_boundaries = {0.1, 0.2, 0.5, 1.0, 2.0, 5.0};

    // Создаем метрику Counter
    auto& request_counter_family = BuildCounter()
        .Name("fibonacci_requests_total")
        .Help("Total number of Fibonacci requests")
        .Register(*registry);
    auto& request_counter = request_counter_family.Add({});

    // Создаем метрику Histogram
    auto& request_time_family = BuildHistogram()
        .Name("fibonacci_request_duration_seconds")
        .Help("Histogram of request durations")
        .Register(*registry);
    auto& request_time = request_time_family.Add({}, bucket_boundaries);

    exposer.RegisterCollectable(registry);

    while (true) {
        int n = rand() % 20 + 1;

        auto start = chrono::high_resolution_clock::now();
        long long result = fibonacci(n);
        auto end = chrono::high_resolution_clock::now();

        double duration = chrono::duration<double>(end - start).count();
        request_time.Observe(duration);  // Записываем время выполнения
        request_counter.Increment();     // Увеличиваем счетчик запросов

        cout << "Fibonacci #" << n << " = " << result << " (Time: " << duration << "s)" << endl;

        this_thread::sleep_for(chrono::seconds(5));
    }
    //sudo docker run --rm -p 8080:8080 salt1s/fibonacci:latest
    return 0;
}