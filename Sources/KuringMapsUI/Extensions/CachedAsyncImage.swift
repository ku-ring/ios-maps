//
//  CachedAsyncImage.swift
//  package-kuring-maps
//
//  Created by Jung Hwan Park on 8/17/26.
//

import SwiftUI
import UIKit

private final class ImageCacheEntry {
    let image: UIImage
    let cachedAt: Date

    init(image: UIImage, cachedAt: Date) {
        self.image = image
        self.cachedAt = cachedAt
    }
}

/*
  건물/시설 이미지를 메모리에 캐싱한다.
  캐시 키는 호출부가 명시적으로 넘기는 식별자(예: `building:\(id)`)를 쓰도록 한다.
  시설의 `imageUrl`은 소속 건물 사진이다.
 */
actor ImageCache {
    static let shared = ImageCache()

    /// 건물 사진은 거의 갱신되지 않지만, 이 시간이 지나면 캐시를 무시하고 다시 받아온다!
    static let defaultTTL: TimeInterval = 60 * 60 * 24 * 7 // 7일

    private let cache = NSCache<NSString, ImageCacheEntry>()
    private var inFlightTasks: [String: Task<UIImage?, Never>] = [:]

    private init() {
        cache.countLimit = 300
    }

    func image(
        for url: URL,
        key: String,
        ttl: TimeInterval = ImageCache.defaultTTL
    ) async -> UIImage? {
        if let cached = cache.object(forKey: key as NSString),
           Date().timeIntervalSince(cached.cachedAt) < ttl {
            return cached.image
        }

        if let existingTask = inFlightTasks[key] {
            return await existingTask.value
        }

        let task = Task<UIImage?, Never> {
            guard let (data, _) = try? await URLSession.imageLoading.data(from: url),
                  let image = UIImage(data: data) else {
                return nil
            }
            return image
        }
        inFlightTasks[key] = task

        let result = await task.value
        inFlightTasks[key] = nil
        if let result {
            cache.setObject(ImageCacheEntry(image: result, cachedAt: Date()), forKey: key as NSString)
        }
        return result
    }
}

extension URLSession {
    /// 건물/시설 썸네일을 동시에 여러 개 받아올 수 있도록 호스트당 동시 연결 수를 늘린 세션.
    static let imageLoading: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 10
        return URLSession(configuration: configuration)
    }()
}

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let cacheKey: String
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
        .task(id: cacheKey) {
            uiImage = nil
            guard let url else {
                return
            }
            uiImage = await ImageCache.shared.image(for: url, key: cacheKey)
        }
    }
}
