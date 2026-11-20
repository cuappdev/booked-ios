//
//  Library.swift
//  Booked
//
//  Created by Alyssa Wang on 9/9/26.
//

import Foundation

struct Library: Identifiable, Equatable, Hashable {
    struct SpaceInfo: Equatable, Hashable {
        var library: String
        var name: String
        var description: String
        var category: String
        var reservationType: ReservationType
        var spaceId: String
    }

    struct Features: Equatable, Hashable {
        var soundLevel: [String]
        var spaceFeatures: [String]
        var spaceType: [String]
        var audienceTypes: [String]
    }

    var id: Int
    var title: String
    var slug: String
    var spaceInfo: SpaceInfo
    var features: Features
    var imageUrl: String?

    var imageURL: URL? {
        guard let imageUrl, let url = URL(string: imageUrl) else { return nil }
        return url
    }

    var displayImageURL: URL? {
        if let imageURL { return imageURL }
        return URL(string: "https://picsum.photos/\(id)?blur=2")
    }
}

//
//  LibraryModel+SampleData.swift
//  Booked
//
//  Dummy data modeled on https://www.library.cornell.edu/libraries/spaces/
//
//  Per-library counts match the site's "Library" filter:
//  Mann 48 · Olin 26 · Uris 16 · Catherwood 11 · Cox 3 · Engineering 3 · Kroch Asia 3 ·
//  Flower-Sprecher Veterinary 2 · Mathematics 2 · Clark Physical Sciences 1 ·
//  Clarke Africana 1 · Library Annex 1   (= 117 spaces)
//
//  `// real`        entries were copied from the live site (names, images, reserve IDs).
//  `// placeholder` entries are generated so the counts/filters behave like the real site.
//  Replace all of this with the real API when it's available.
//

extension Library {
    static let sampleData: [Library] =
        mann + olin + uris + catherwood + cox + engineering + krochAsia
        + veterinary + mathematics + physicalSciences + africana + annex
}

// MARK: - Mann Library (48)

private extension Library {
    static let mann: [Library] = {
        var spaces: [Library] = [
        // real
        space(id: 30001, "Bissett Collaborative Workstation 1", "bissett-collab-1", "Mann Library",
              location: "1st Floor", "Shared collaborative workstation in the Bissett Design Center.",
              .collaborativeSpace, .reservable, spaceId: "18630", sound: ["Collaborative"],
              features: ["Monitor/Zoom"], types: ["Study and Talk with a Group"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2022/11/Bissett-workstation-scaled-aspect-ratio-453-342-1.jpg"),
        space(id: 30002, "Bissett Collaborative Workstation 2", "bisset-collab-2", "Mann Library",
              location: "1st Floor", "Shared collaborative workstation in the Bissett Design Center.",
              .collaborativeSpace, .reservable, spaceId: "18631", sound: ["Collaborative"],
              features: ["Monitor/Zoom"], types: ["Study and Talk with a Group"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2022/11/Bissett-workstation-scaled-aspect-ratio-453-342.jpg"),
        space(id: 9516, "Mann Library Serenity Room", "serenity", "Mann Library",
              location: "2nd Floor", "Room 282",
              "Interfaith Serenity Room", .byRequest, sound: ["Quiet"],
              features: ["Lounge seating"], types: [],
              audience: ["Faculty", "Graduate", "Undergraduate"],
              image: "https://library.cornell.edu/wp-content/uploads/2023/05/P1133611-1-scaled-aspect-ratio-453-342.jpg"),
    ]
    // placeholder (45)
    spaces += series(1...14, idBase: 30100, library: "Mann Library", title: "Mann Group Study Room", slug: "mann-group",
             floors: ["1st Floor", "2nd Floor", "3rd Floor"],
             description: "Reservable group study room that seats up to 6. Whiteboard available.",
             .groupStudy, .reservable, sound: ["Collaborative"],
             types: ["Study and Talk with a Group"], features: roomFeatures)
    spaces += series(3...12, idBase: 30200, library: "Mann Library", title: "Mann Collaborative Workstation", slug: "mann-collab",
             floors: ["1st Floor"],
             description: "Open workstation with a shared monitor for group projects.",
             .collaborativeSpace, .reservable, sound: ["Collaborative"],
             types: ["Study and Talk with a Group"], features: { _ in ["Monitor/Zoom"] })
    spaces += series(1...8, idBase: 30300, library: "Mann Library", title: "Mann Quiet Study Carrel", slug: "mann-carrel",
             floors: ["2nd Floor", "3rd Floor"],
             description: "Individual carrel for focused, quiet work.",
             .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
             features: { _ in ["Power outlets"] })
    spaces += series(1...6, idBase: 30400, library: "Mann Library", title: "Mann Reading Room Table", slug: "mann-reading",
             floors: ["1st Floor"],
             description: "Shared reading table in the main reading room.",
             .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
             features: { _ in ["Window"] })
    spaces += series(1...4, idBase: 30500, library: "Mann Library", title: "Mann Instruction Room", slug: "mann-instruction",
             floors: ["1st Floor", "2nd Floor"],
             description: "Instruction room available by request for classes and workshops.",
             .conferenceRoom, .byRequest, sound: ["Collaborative"], types: ["Present or Teach"],
             features: { _ in ["Monitor/Zoom", "Accessible"] })
    spaces += series(1...3, idBase: 30600, library: "Mann Library", title: "Mann Lounge Seating", slug: "mann-lounge",
             floors: ["1st Floor"],
             description: "Soft seating for relaxed study and conversation.",
             .openStudy, .walkIn, sound: ["Collaborative"], types: ["Study and Talk with a Group"],
             features: { _ in ["Lounge seating"] })
        return spaces
    }()
}

// MARK: - Olin Library (26)

private extension Library {
    static let olin: [Library] = {
        var spaces: [Library] = [
        // real
        space(id: 31001, "Amit Bhatia Libe Café", "amit-bhatia-libe-cafe", "Olin Library",
              location: "1st Floor", "Café space on the first floor of Olin Library.",
              "Lounge", .walkIn, sound: ["Collaborative"], features: ["Café"],
              types: ["Study and Talk with a Group"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2023/07/Olin-Cafe-1st-floor-scaled-aspect-ratio-453-342.jpeg"),
        space(id: 16612, "Olin 120B Group Study", "olin-120b", "Olin Library",
              location: "Olin 120B", "Group study room. Seats 4. Only available after 6pm M-F. Available all day on weekends.",
              .collaborativeSpace, .reservable, spaceId: "183114", sound: ["Collaborative"],
              features: ["DTEN monitor/Zoom"], types: ["Study and Talk with a Group"]),
        space(id: 16608, "Olin 120A Group Study", "olin-120a", "Olin Library",
              location: "Olin 120A Group Study", "Group study room. Seats 4. Only available after 6pm M-F. Available all day on weekends.",
              .collaborativeSpace, .reservable, spaceId: "183113", sound: ["Collaborative"],
              features: ["DTEN monitor/Zoom"], types: ["Study and Talk with a Group"],
              audience: ["Undergraduate", "Graduate", "Staff", "Faculty"]),
    ]
    // placeholder (23)
    spaces += series(1...9, idBase: 31100, library: "Olin Library", title: "Olin Group Study Room", slug: "olin-group",
             floors: ["1st Floor", "2nd Floor", "3rd Floor"],
             description: "Reservable group study room that seats up to 6.",
             .groupStudy, .reservable, sound: ["Collaborative"],
             types: ["Study and Talk with a Group"], features: roomFeatures)
    spaces += series(1...6, idBase: 31200, library: "Olin Library", title: "Olin Open Study Table", slug: "olin-open",
             floors: ["2nd Floor", "3rd Floor"],
             description: "Shared table for quiet study.",
             .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
             features: { _ in ["Window", "Power outlets"] })
    spaces += series(1...5, idBase: 31300, library: "Olin Library", title: "Olin Silent Study Carrel", slug: "olin-silent",
             floors: ["4th Floor"],
             description: "Individual carrel in the silent study area.",
             .openStudy, .walkIn, sound: ["Silent"], types: ["Study or Work Alone"],
             features: { _ in ["Power outlets"] })
    spaces += series(1...3, idBase: 31400, library: "Olin Library", title: "Olin Collaborative Workstation", slug: "olin-collab",
             floors: ["1st Floor"],
             description: "Open workstation with a shared monitor.",
             .collaborativeSpace, .reservable, sound: ["Collaborative"],
             types: ["Study and Talk with a Group"], features: { _ in ["DTEN monitor/Zoom"] })
        return spaces
    }()
}

// MARK: - Uris Library (16)

private extension Library {
    static let uris: [Library] = {
        var spaces: [Library] = [
        // real
        space(id: 32001, "AD White Library", "uris-ad-white", "Uris Library",
              location: "Level 1", "The historic A.D. White Library reading room.",
              .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2023/07/image_67224321-scaled-aspect-ratio-453-342.jpg"),
        space(id: 8626, "Uris 4B04 Cocktail Lounge Study Room", "uris-4b04", "Uris Library",
              location: "Level 4B", "Uris 4B04 Cocktail Lounge Study Room. This room is located in the Cocktail Lounge of Uris Library. A dry erase board is available for use; markers are available to be checked-out at the Olin Circulation Desk during open hours.",
              .groupStudy, .reservable, spaceId: "5649", sound: ["Collaborative"],
              types: ["Study and Talk with a Group"], audience: ["Graduate", "Undergraduate"],
              image: "https://library.cornell.edu/wp-content/uploads/2022/11/picture_of_the_cocktail_lounge_group_study_rooms-scaled-aspect-ratio-453-342-1.jpeg"),
        space(id: 8625, "Uris 4B03 Cocktail Lounge Study Room", "uris-4b03", "Uris Library",
              location: "Level 4B", "Uris 4B03 Cocktail Lounge Study Room. This room is located in the Cocktail Lounge of Uris Library. A dry erase board is available for use; markers are available to be checked-out at the Olin Circulation Desk during open hours.",
              .groupStudy, .reservable, spaceId: "5648", sound: ["Collaborative"],
              types: ["Study and Talk with a Group"], audience: ["Graduate", "Undergraduate"],
              image: "https://library.cornell.edu/wp-content/uploads/2022/11/picture_of_the_cocktail_lounge_group_study_rooms-scaled-aspect-ratio-453-342-3.jpeg"),
        space(id: 8624, "Uris 4B02 Cocktail Lounge Study Room", "uris-4b02", "Uris Library",
              location: "Level 4B", "Uris 4B02 Cocktail Lounge Study Room. This room is located in the Cocktail Lounge of Uris Library. A dry erase board is available for use; markers are available to be checked-out at the Olin Circulation Desk during open hours.",
              .groupStudy, .reservable, spaceId: "5647", sound: ["Collaborative"],
              types: ["Study and Talk with a Group"], audience: ["Graduate", "Undergraduate"],
              image: "https://library.cornell.edu/wp-content/uploads/2022/11/picture_of_the_cocktail_lounge_group_study_rooms-scaled-aspect-ratio-453-342-2.jpeg"),
        space(id: 8623, "Uris Cocktail Lounge Open Study", "uris-cocktail-lounge", "Uris Library",
              location: "Level 4B", "Cocktail Lounge",
              .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
              audience: ["Undergraduate", "Graduate", "Staff", "Faculty", "Visitor"],
              image: "https://library.cornell.edu/wp-content/uploads/2023/05/P1133523-scaled-aspect-ratio-453-342.jpg"),
    ]
    // placeholder (11)
    spaces += series(1...4, idBase: 32100, library: "Uris Library", title: "Uris Group Study Room", slug: "uris-group",
             floors: ["Level 2", "Level 3"],
             description: "Reservable group study room that seats up to 6.",
             .groupStudy, .reservable, sound: ["Collaborative"],
             types: ["Study and Talk with a Group"], features: roomFeatures)
    spaces += series(1...4, idBase: 32200, library: "Uris Library", title: "Uris Reading Room Table", slug: "uris-reading",
             floors: ["Level 1", "Level 2"],
             description: "Shared table for quiet study.",
             .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
             features: { _ in ["Window"] })
    spaces += series(1...3, idBase: 32300, library: "Uris Library", title: "Uris Silent Carrel", slug: "uris-silent",
             floors: ["Level 3"],
             description: "Individual carrel in the silent study area.",
             .openStudy, .walkIn, sound: ["Silent"], types: ["Study or Work Alone"],
             features: { _ in ["Power outlets"] })
        return spaces
    }()
}

// MARK: - Catherwood Library (11)

private extension Library {
    static let catherwood: [Library] = [
        // real
        space(id: 33001, "Catherwood 136 Table A", "catherwood-136-a", "Catherwood Library",
              location: "Room 136", "Reservable table in the Catherwood collaborative area.",
              .collaborativeSpace, .reservable, spaceId: "110724", sound: ["Collaborative"],
              features: ["Reservable"], types: ["Study and Talk with a Group"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2023/02/136ABC-Catherwood-scaled-aspect-ratio-453-342-2.jpg"),
        space(id: 33002, "Catherwood 136 Table B", "catherwood-136-b", "Catherwood Library",
              location: "Room 136", "Reservable table in the Catherwood collaborative area.",
              .collaborativeSpace, .reservable, spaceId: "110725", sound: ["Collaborative"],
              features: ["Reservable"], types: ["Study and Talk with a Group"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2023/02/136ABC-Catherwood-scaled-aspect-ratio-453-342.jpg"),
        space(id: 33003, "Catherwood 136 Table C", "catherwood-136-c", "Catherwood Library",
              location: "Room 136", "Reservable table in the Catherwood collaborative area.",
              .collaborativeSpace, .reservable, spaceId: "110726", sound: ["Collaborative"],
              features: ["Reservable"], types: ["Study and Talk with a Group"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2023/02/136ABC-Catherwood-scaled-aspect-ratio-453-342-1.jpg"),
        space(id: 33004, "Catherwood 1st Floor Open Study", "catherwood-1st-floor", "Catherwood Library",
              location: "1st Floor", "Quiet open study space on the first floor.",
              .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2023/02/1st-fl-quiet-cath-aspect-ratio-453-342.jpg"),
        space(id: 33005, "Catherwood 230 Interview Room", "catherwood-230", "Catherwood Library",
              location: "Room 230", "Private room for interviews and calls.",
              .conferenceRoom, .reservable, spaceId: "19594", sound: ["Collaborative"],
              features: ["Reservable"], types: ["Present or Teach"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2023/02/230-interview-rm-cath-aspect-ratio-453-342.jpg"),
        space(id: 33006, "Catherwood 231A Group Study", "catherwood-231a", "Catherwood Library",
              location: "Room 231A", "Reconfigurable shared group study space accommodating 2-6 students. It comes equipped with wheeled chairs, tables and whiteboards. Dry erase markers are available at the circulation desk.",
              .groupStudy, .reservable, spaceId: "3837", sound: ["Collaborative"],
              features: ["Accessible", "Reservable", "Whiteboard", "Window"], types: ["Study and Talk with a Group"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2022/11/231_B-scaled-aspect-ratio-453-342.jpeg"),
        space(id: 33007, "Catherwood 231B Group Study", "catherwood-231b", "Catherwood Library",
              location: "Room 231B", "Reconfigurable shared group study space accommodating 2-6 students. It comes equipped with wheeled chairs, tables and whiteboards.",
              .groupStudy, .reservable, spaceId: "3838", sound: ["Collaborative"],
              features: ["Accessible", "Reservable", "Whiteboard", "Window"], types: ["Study and Talk with a Group"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2022/11/231_A-2-scaled-aspect-ratio-453-342.jpeg"),
        // placeholder (4)
        space(id: 33101, "Catherwood 2nd Floor Open Study", "catherwood-2nd-floor", "Catherwood Library",
              location: "2nd Floor", "Quiet open study tables on the second floor.",
              .openStudy, .walkIn, sound: ["Quiet"], features: ["Window"], types: ["Study or Work Alone"]),
        space(id: 33102, "Catherwood Reading Room", "catherwood-reading-room", "Catherwood Library",
              location: "1st Floor", "Reading room with individual and shared tables.",
              .openStudy, .walkIn, sound: ["Silent"], types: ["Study or Work Alone"]),
        space(id: 33103, "Catherwood 2nd Floor Group Study", "catherwood-2nd-group", "Catherwood Library",
              location: "2nd Floor", "Reservable group study room that seats up to 6.",
              .groupStudy, .reservable, spaceId: "933103", sound: ["Collaborative"],
              features: ["Whiteboard"], types: ["Study and Talk with a Group"]),
        space(id: 33104, "Catherwood Quiet Study Carrels", "catherwood-carrels", "Catherwood Library",
              location: "1st Floor", "Individual carrels for focused, quiet work.",
              .openStudy, .walkIn, sound: ["Silent"], features: ["Power outlets"],
              types: ["Study or Work Alone"]),
    ]
}

// MARK: - Cox Library of Music and Dance (3), Engineering (3), Kroch Asia (3)

private extension Library {
    // placeholder
    static let cox: [Library] = [
        space(id: 34001, "Cox Library Open Study", "cox-open-study", "Cox Library of Music and Dance",
              location: "Lincoln Hall 220", "Quiet study tables among the music and dance collections.",
              .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"]),
        space(id: 34002, "Cox Listening Room", "cox-listening-room", "Cox Library of Music and Dance",
              location: "Lincoln Hall 220", "Listening and viewing room, available by request.",
              "Listening Room", .byRequest, sound: ["Quiet"], features: ["Audio equipment"],
              types: ["Study or Work Alone"]),
        space(id: 34003, "Cox Group Study Room", "cox-group-study", "Cox Library of Music and Dance",
              location: "Lincoln Hall 220", "Reservable group study room.",
              .groupStudy, .reservable, spaceId: "934003", sound: ["Collaborative"],
              features: ["Whiteboard"], types: ["Study and Talk with a Group"]),
    ]

    // placeholder
    static let engineering: [Library] = [
        space(id: 35001, "Engineering Library Open Study", "engineering-open-study", "Engineering Library",
              location: "Carpenter Hall", "Open study space with individual and shared tables.",
              .openStudy, .walkIn, sound: ["Quiet"], features: ["Power outlets"], types: ["Study or Work Alone"]),
        space(id: 35002, "Engineering 24-Hour Study Space", "engineering-24-hour", "Engineering Library",
              location: "Carpenter Hall", "Study space open around the clock.",
              .openStudy, .walkIn, sound: ["Collaborative"], features: ["Power outlets", "Accessible"],
              types: ["Study and Talk with a Group"]),
        space(id: 35003, "Engineering Group Study Room", "engineering-group-study", "Engineering Library",
              location: "Carpenter Hall", "Reservable group study room with a whiteboard.",
              .groupStudy, .reservable, spaceId: "935003", sound: ["Collaborative"],
              features: ["Whiteboard", "Monitor/Zoom"], types: ["Study and Talk with a Group"]),
    ]

    // real
    static let krochAsia: [Library] = [
        space(id: 8629, "Kroch B59 Cho Room", "kroch-b59", "Kroch Asia Collections",
              location: "Cho Room", "Kroch B59",
              .conferenceRoom, .byRequest, sound: ["Collaborative"], types: ["Present or Teach"],
              audience: ["Graduate", "Faculty"],
              image: "https://library.cornell.edu/wp-content/uploads/2023/02/cho-room-aspect-ratio-453-342.jpg"),
        space(id: 8628, "Kroch B60 Rawson Reading Room", "kroch-b60", "Kroch Asia Collections",
              location: "Rawson Reading Room", "Kroch B60",
              .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
              image: "https://library.cornell.edu/wp-content/uploads/2023/02/rawson-reading-room-aspect-ratio-453-342.jpg"),
        space(id: 8627, "Severinghaus Asia Reading Room", "kroch-severinghaus", "Kroch Asia Collections",
              location: "1st Floor", "Severinghaus Asia Reading Room",
              .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
              image: "https://library.cornell.edu/wp-content/uploads/2023/02/sevringhaus-reading-room-aspect-ratio-453-342.jpg"),
    ]
}

// MARK: - Veterinary (2), Mathematics (2), Clark (1), Africana (1), Annex (1)

private extension Library {
    // placeholder
    static let veterinary: [Library] = [
        space(id: 36001, "Vet Library Open Study", "vet-open-study", "Flower-Sprecher Veterinary Library",
              location: "Veterinary Education Center", "Quiet open study space.",
              .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"]),
        space(id: 36002, "Vet Library Group Study Room", "vet-group-study", "Flower-Sprecher Veterinary Library",
              location: "Veterinary Education Center", "Reservable group study room.",
              .groupStudy, .reservable, spaceId: "936002", sound: ["Collaborative"],
              features: ["Whiteboard"], types: ["Study and Talk with a Group"]),
    ]

    // placeholder
    static let mathematics: [Library] = [
        space(id: 37001, "Mathematics Library Open Study", "math-open-study", "Mathematics Library",
              location: "Malott Hall 420", "Quiet study space with whiteboards.",
              .openStudy, .walkIn, sound: ["Quiet"], features: ["Whiteboard"], types: ["Study or Work Alone"]),
        space(id: 37002, "Mathematics Library Group Study Room", "math-group-study", "Mathematics Library",
              location: "Malott Hall 420", "Reservable group study room with a whiteboard wall.",
              .groupStudy, .reservable, spaceId: "937002", sound: ["Collaborative"],
              features: ["Whiteboard"], types: ["Study and Talk with a Group"]),
    ]

    // placeholder
    static let physicalSciences: [Library] = [
        space(id: 38001, "Clark Physical Sciences 24/7 Study Space", "clark-24-7", "Clark Physical Sciences Library",
              location: "Clark Hall", "Study space open 24/7.",
              .openStudy, .walkIn, sound: ["Quiet"], features: ["Power outlets", "Accessible"],
              types: ["Study or Work Alone"]),
    ]

    // real
    static let africana: [Library] = [
        space(id: 39001, "Africana Library 1st Floor Open Study", "africana-1st-floor", "Clarke Africana Library",
              location: "1st Floor", "Open study space on the first floor of the Africana Library.",
              .openStudy, .walkIn, sound: ["Quiet"], types: ["Study or Work Alone"],
              image: "https://www.library.cornell.edu/wp-content/uploads/2025/07/13-aspect-ratio-453-342.jpg"),
    ]

    // placeholder
    static let annex: [Library] = [
        space(id: 40001, "Library Annex Reading Room", "annex-reading-room", "Library Annex",
              location: "Main Floor", "Reading room for requested materials. Access by request.",
              .openStudy, .byRequest, sound: ["Silent"], types: ["Study or Work Alone"]),
    ]
}

// MARK: - Builders

/// Categories already used by the app's filters.
private extension String {
    static let openStudy = "Open Study"
    static let groupStudy = "Group Study"
    static let collaborativeSpace = "Collaborative Space"
    static let conferenceRoom = "Conference Room"
}

private extension Library {
    static let everyone = ["Undergraduate", "Graduate", "Staff", "Faculty"]

    static func roomFeatures(_ n: Int) -> [String] {
        if n % 3 == 0 { return ["Whiteboard", "Monitor/Zoom", "Accessible"] }
        if n % 2 == 0 { return ["Whiteboard", "Window"] }
        return ["Whiteboard"]
    }

    static func space(
        id: Int, _ title: String, _ slug: String, _ library: String,
        location: String, _ description: String,
        _ category: String, _ reservation: ReservationType, spaceId: String = "",
        sound: [String], features: [String] = [], types: [String],
        audience: [String]? = nil, image: String? = nil
    ) -> Library {
        Library(
            id: id, title: title, slug: slug,
            spaceInfo: .init(
                library: library, name: location, description: description,
                category: category, reservationType: reservation, spaceId: spaceId
            ),
            features: .init(
                soundLevel: sound, spaceFeatures: features,
                spaceType: types, audienceTypes: audience ?? everyone
            ),
            imageUrl: image
        )
    }

    /// Generates numbered placeholder spaces ("Mann Group Study Room 1...14").
    static func series(
        _ numbers: ClosedRange<Int>, idBase: Int, library: String, title: String, slug: String,
        floors: [String], description: String,
        _ category: String, _ reservation: ReservationType,
        sound: [String], types: [String], features: (Int) -> [String]
    ) -> [Library] {
        numbers.map { n in
            space(
                id: idBase + n, "\(title) \(n)", "\(slug)-\(n)", library,
                location: floors[(n - numbers.lowerBound) % floors.count], description,
                category, reservation,
                spaceId: reservation == .reservable ? "\(900_000 + idBase + n)" : "",
                sound: sound, features: features(n), types: types
            )
        }
    }
}
