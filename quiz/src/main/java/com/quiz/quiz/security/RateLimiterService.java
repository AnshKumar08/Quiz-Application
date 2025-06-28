package com.quiz.quiz.security;

import org.springframework.stereotype.Service;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class RateLimiterService {

    private final Map<String, Deque<Long>> requestCounts = new ConcurrentHashMap<>();

    public synchronized boolean tryAcquire(String key, int maxRequests, long windowMillis) {
        long now = System.currentTimeMillis();
        long windowStart = now - windowMillis;

        // Periodic maintenance to prevent map from growing unbounded under distributed traffic
        if (requestCounts.size() > 5000) {
            requestCounts.entrySet().removeIf(entry -> {
                Deque<Long> queue = entry.getValue();
                while (!queue.isEmpty() && queue.peekFirst() < windowStart) {
                    queue.pollFirst();
                }
                return queue.isEmpty();
            });
        }

        Deque<Long> timestamps = requestCounts.computeIfAbsent(key, k -> new ArrayDeque<>());

        // Evict expired timestamps
        while (!timestamps.isEmpty() && timestamps.peekFirst() < windowStart) {
            timestamps.pollFirst();
        }

        if (timestamps.size() < maxRequests) {
            timestamps.addLast(now);
            return true;
        }

        return false;
    }

    public synchronized void reset(String key) {
        requestCounts.remove(key);
    }
}
