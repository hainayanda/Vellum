<p align="center">
  <img width="192" height="166" src="Vellum.png"/>
</p>

# Vellum

[![codebeat badge](https://codebeat.co/badges/acb3125f-c1dc-4931-8c61-11780703e29a)](https://codebeat.co/projects/github-com-hainayanda-vellum-main)
![build](https://github.com/hainayanda/Vellum/workflows/build/badge.svg)
![test](https://github.com/hainayanda/Vellum/workflows/test/badge.svg)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/cocoapods/v/Vellum.svg?style=flat)](https://cocoapods.org/pods/Vellum)
[![License](https://img.shields.io/cocoapods/l/Vellum.svg?style=flat)](https://cocoapods.org/pods/Vellum)
[![Platform](https://img.shields.io/cocoapods/p/Vellum.svg?style=flat)](https://cocoapods.org/pods/Vellum)

## Requirements

- Swift 5.0 or higher
- iOS 9.3 or higher

## Installation

### Cocoapods

Vellum is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Vellum'
```

### Swift Package Manager from XCode

- Add it using XCode menu **File > Swift Package > Add Package Dependency**
- Add **https://github.com/hainayanda/Vellum.git** as Swift Package URL
- Set rules at **version**, with **Up to Next Major** option and put **1.2.3** as its version
- Click next and wait

### Swift Package Manager from Package.swift

Add as your target dependency in **Package.swift**

```swift
dependencies: [
    .package(url: "https://github.com/hainayanda/Vellum.git", .upToNextMajor(from: "1.2.3"))
]
```

Use it in your target as `Vellum`

```swift
 .target(
    name: "MyModule",
    dependencies: ["Vellum"]
)
```

Then run swift build to build the dependency before you use it

## Author

Nayanda Haberty, hainayanda@outlook.com

## License

Vellum is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Storage Algorithm
Vellum is using LRU Algorithm. It contains 2 type of storage which is `Memory Storage` and `Disk Storage`. Both sizes can be assigned manually.

### Store Data

![alt text](https://github.com/hainayanda/Vellum/blob/main/Storing_Algorithm.png)

1. Store data to Memory Storage
2. If Memory Storage is full, it will remove the oldest accessed data from memory until space is enough for new data
3. Data stored in the memory
4. Store data to Disk Storage
5. If Disk Storage is full, it will remove the oldest accessed data from memory until space is enough for new data
6. Data stored to the disk

### Getting Data

![alt text](https://github.com/hainayanda/Vellum/blob/main/Accessing_Algorithm.png)

1. Find data from the Memory Storage
2. If the data exist, it will return the data and the step ended
3. If the data do not exist in the memory, it will try  to find data from Disk Storage
4. If the data exist, it will store the data to the Memory Storage for future faster use and return the data and the step ended
5. If the data do not exist, it will return nil

## Usage Example

### Basic Usage

All you need to do is just get the `ArchiveManager` from factory and store your object which implement `Archivable` and `Codable` or using `typealias` `ArchiveCodable` which is the same:

```swift
let archives = try! ArchivesFactory.shared.archives(
    for: MyArchivable.self,
    trySetMaxMemorySize: 10.megaByte, 
    trySetMaxDiskSize: 20.megaByte
)

// will insert object
archives.record(myObject)

let object = archives.access(archiveWithKey: "object_key")
```

### Archivable

`Archivable` actually is just a protocol that has methods to convert an object to data or vice versa. `Archivable` make sure the object has keys too:

```swift
class User: Archivable {
    
    var primaryKey: String { userName }
    var userName: String = ""
    var fullName: String = ""
    var age: Int = 0
    
    func archive() throws -> Data {
        // do something to convert the object to Data
    }
    
    static func deArchive(fromData data: Data) throws -> Archivable {
        // do something to convert the data to object
    }
}
```
### ArchiveCodable

If your object is `Codable`, just add `Archivable` or using `typealias` `ArchiveCodable` which is the same, your object will have those methods automatically. You just need to add `primaryKey` property you want as the primary key as long as the value is `String`:

```swift
struct User: Codable, Archivable {
    var primaryKey: String { userName }
    var userName: String
    var fullName: String
    var age: Int
}
```

### ArchiveManager

To get `ArchiveManager`, you can use `ArchivesFactory`. You can assign the maximum size in bytes for memory size and disk size. But keep in mind, the size will only apply on the first creation of the `ArchiveManager`, If the cache manager is already created, then the memory size and disk size is ignored. If you don't assign the memory size or disk size, it will use the default value which is 1 megabyte for memory and 2 megabyte disk size:

```swift
let archives = try! ArchivesFactory.shared.archives(
    for: User.self, 
    trySetMaxMemorySize: 10.kiloByte, 
    trySetMaxDiskSize: 20.kiloByte
)

// or not explicit
let sameArchives: ArchiveManager<User> = try! ArchivesFactory.shared.archives( 
    trySetMaxMemorySize: 10.kiloByte, 
    trySetMaxDiskSize: 20.kiloByte
)
```

the `ArchiveManager` have some usable methods and property which are:
- `var maxSize: Int { get }` to get maximum size of the cache
- `var currentSize: Int { get }` to get current used size of the cache
- `func latestAccessedTime(for key: String) -> Date?` to  get the latest time the object with same key accessed
- `func deleteAllInvalidateArchives(invalidateTimeInterval: TimeInterval)` to remove all object older than time interval
- `func record(_ object: Archive)` to insert object
- `func update(_ object: Archive)` to update existing object, or insert if have none
- `func access(archiveWithKey key: String) -> Archive?` to get object with given key
- `func accessAll(limitedBy limit: Int) -> [Archive]` to get all object limited by limit
- `func accessAll() -> [Archive]` to get all object stored in cache
- `func delete(archiveWithKey key: String)` to delete object with given key
- `func deleteAll()` to remove all object from cache
- `func process(queries: [Query<Archive>]) -> [Archive]` to process query. This will be disucessed later

### Query

You can do a query from the cache. there are 3 types of query which are:
- `QueryFinder` to find the object/results by its properties
- `QuerySorter` to sort the results by its properties
- `QueryLimiter` to limit the results by limit

 All Query can be combined and will executed sequentially:
 
```swift
let results = userCache.findWhere { archive in
    archive.userName(.contains("premium"))
        .fullName(.isNotEqual(nil))
}
.getResults()
```

The code above will find all users in the cache whose userName contains "premium" and its fullName is not nill. The result is an array of User

```swift
let results = userCache.sorted { by in 
    by.age(.ascending)
        .fullName(.descending)
}
.getResults()
```

The code above will get all users in cache and sorted it by its age ascendingly and then its fullName descendingly. The results are sorted array  of User

You can add the limit too

```swift
let results = userCache.sorted { by in 
    by.age(.ascending)
        .fullName(.descending)
}
.limitResults(by: 10)
.getResults()
```

The code above will limit the results maximum of just 10

You can even combine the query if you want:

```swift
let results = userCache.findWhere { archive in
    archive.userName(.contains("premium"))
        .fullName(.isNotEqual(nil))
}
.sorted { by in 
    by.age(.ascending)
        .fullName(.descending)
}
.limitResults(by: 10)
.getResults()
```

The code above will find all users in the cache whose userName contains "premium" and its fullName is not nill, then sort it by its age ascendingly and then its fullName descendingly. The results are limited by 10.

here are the list of finder that can be used with `QueryFinder`:
- `contains(string: )` match if string property contains given string
- `matches(regex: )` match if string property matches with given regex
- `contains(with: )` match if collection property is contains given element
- `contains(atLeastOne: )` match if collection property contains at least one of given element
- `contains(all: )` match if collection property contains all given element
- `countEqual(with: )` match if collection property count equal with given number
- `countGreater(than: )` match if collection property count greater than given number
- `countLess(than: )` match if collection property count less than given number
- `countGreaterOrEqual(with: )` match if collection property count greater than or equal with given number
- `countLessOrEqual(with: )` match if collection property count greater than or equal with given number
- `isEqual(with: )` match if property equal with given value
- `isNotEqual(with: )` match if property not equal with given value
- `greater(than: )` match if property greater than given value
- `less(than: )` match if property less than given value
- `greaterOrEqual(with: )` match if property greater than or equal with given value
- `lessOrEqual(with: )` match if property less than or equal with given value

if you want to validate manually, you can just use `isValid(_ validator: (Property) -> Bool)`:

```swift
let results = userCache.findWhere { archive in
    archive.userName(.isValid { $0.contains("premium") })
}
.getResults()
```

### Property Wrapper

You could use `Archived` property wrapper to wrapped any property so if it assigned it will automatically store those properties into `ArchiveManager`:

```swift
@Archived var user: User?
```

if you want the property to have an initial value based on the given primary key, just pass the key: 

```swift
@Archived(initialPrimaryKey: "some") var user: User?
```

Code above will try to get the user with the given key at first property load.
