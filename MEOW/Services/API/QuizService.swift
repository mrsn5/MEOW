//
//  QuizService.swift
//  MEOW
//
//  Created by San Byn Nguyen on 23.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import Foundation

class QuizService {
    
    private var breedsService: BreedService
    private var catImageService: CatImageService
    
    private var selectedBreeds: [Breed] = []
    private let concurrentCancellationQueue: DispatchQueue
    
    init() {
        self.breedsService = BreedService(dataService: CodableService(cache: FileStorage.shared, policy: .loadCacheElseLoad))
        self.catImageService = CatImageService(dataService: Webservice())
        self.concurrentCancellationQueue =
            DispatchQueue(
                label: "\(UUID()).\(Self.self).concurrentCancellationQueue",
                attributes: .concurrent)
    }
    
    func generateQuiz(handler: @escaping (Result<Quiz, ServiceError>) -> ()) {
        breedsService.fetch { [weak self] result in
            if case .success(let breeds) = result {
                guard let breeds = breeds else {
                    handler(.failure(.network(description: "No breeds found")))
                    return
                }
                
                self?.makeQuiz(from: breeds, handler: handler)
            } else if case .failure(let error) = result {
                handler(.failure(error))
            }
        }
    }
    
    
    func makeQuiz(
        from breeds: [Breed],
        handler: @escaping (Result<Quiz, ServiceError>) -> ())
    {
        cancel()
        var questions: [Question] = []
        selectedBreeds = Array(breeds.shuffled().prefix(10))
        let group = DispatchGroup()
        
        
        for b in selectedBreeds {
            group.enter()
            catImageService.fetch(count: 10, breedId: b.id, order: "RANDOM") { [weak self] result in
                if case .failure(let error) = result {
                    handler(.failure(error))
                    self?.cancel()
                } else if case .success(let value) = result {
                    guard let images = value, images.count >= 1 else {
                        self?.cancel()
                        handler(.failure(.network(description: "No cat images detected")))
                        return
                    }
                    let catImage = images.shuffled()[0]
                    
                    if let self = self {
                        if 7 > Int.random(in: 0...10) {
                            questions.append(self.breedQuestion(breed: b, catImage: catImage, breeds: breeds))
                        } else {
                            questions.append(self.countryQuestions(breed: b, catImage: catImage, breeds: breeds))
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            handler(.success(Quiz(questions: questions)))
        }
    }
    
    func breedQuestion(breed: Breed, catImage: CatImage, breeds: [Breed]) -> Question {
        return Question(
                question: "What is this breed?",
                image: catImage.url,
                rightAnswer: breed.name,
                otherOptions: breeds.shuffled()
                    .filter { $0 != breed }
                    .prefix(3)
                    .map { $0.name },
                catImage: catImage
        )
    }
    
    func countryQuestions(breed: Breed, catImage: CatImage, breeds: [Breed]) -> Question {
        let countries: [String] = Array(Set(breeds
            .filter { $0.countryCode != breed.countryCode }
            .map { $0.country() }))
        
        return Question(
                question: "Where am I from?",
                image: catImage.url,
                rightAnswer: breed.country(),
                otherOptions: Array(countries.prefix(3)),
                catImage: catImage
        )
    }
    
    
    func cancel() {
        concurrentCancellationQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            for b in self.selectedBreeds {
                self.catImageService.cancel(count: 1, breedId: b.id, order: "RANDOM", handler: nil)
            }
            self.selectedBreeds.removeAll()
        }
    }
    
}

