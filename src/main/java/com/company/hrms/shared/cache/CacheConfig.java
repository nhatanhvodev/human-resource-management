package com.company.hrms.shared.cache;

import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * P1: in-memory cache for hot RBAC reads (per-request authority resolution).
 * ConcurrentMap is enough for a single replica and keeps tests hermetic
 * (no Redis server required). When scaling horizontally, replace this bean
 * with a RedisCacheManager (spring-data-redis is already on the classpath)
 * with a short TTL (e.g. 5 minutes) — eviction annotations stay unchanged.
 */
@Configuration
@EnableCaching
public class CacheConfig {

    public static final String RBAC_ACCESS = "rbacAccess";
    public static final String RBAC_IDP = "rbacIdp";

    @Bean
    CacheManager cacheManager() {
        ConcurrentMapCacheManager manager = new ConcurrentMapCacheManager(RBAC_ACCESS, RBAC_IDP);
        manager.setAllowNullValues(false);
        return manager;
    }
}
