# Codix

### What is Codix

Codix is an extension for Decodable, make it more elegant and more easire to decode model from json.

### AnyDecoder decode at path

```swift
let json = """
{
  "response": {
    "users": [
      {
        "id": 78893,
        "name": "Jerry"
      }
    ]
  }
}
""".data(using: .utf8)!

struct User: Decodable {
  let id: Int
  let name: String
}

let user = try JSONDecoder().decode(User.self, from: json, at: "response.users[0]")
```

### Decodable decode at path

```swift
let json = """
{
  "response": {
    "users": {
      "my_id": 78893,
      "nick_name": "Jerry",
      "profile": {
        "birth_day": "2000/08/12",
        "avatar": "https://images.baidu.com/avatars/27883.jpg",
        "role": "student"
      }
      "salary": "usd:4500",
      "male": "true"
    }
  }
}
""".data(using: .utf8)!

enum Role: String, Decodable {
  case student
  case teacher
  case parent
}

enum Salary {
  case usd(Int)
  case rmb(Int)
}

struct SalaryTransformer: Transformer {
  func transform(_ value: String) throws -> Salary {
    let components = value.split(separator: ":")
    guard components.count == 2,
    components[0] == "usd" || components[0] == "rmb",
    let amount = Int(component[1]) else {
      throw CodixError.transformFailed("Can not transform \(value) to Enum Salary")
    }
    
    if components[0] == "usd" {
      return .usd(amount)
    } else {
      return .rmb(amount)
    }
  }
}

struct User: Decodable {
  let id: Int
  let name: String
  let birthdate: Date?
  let avatar: URL?
  let role: Role
  let salary: Salary
  let isMale: Bool
  
  init(from decoder: Decoder) throws {
    id = try decoder.decode(at: "my_id")
    name = try decoder.decode(at: "nick_name")
    birthdate = try decoder.decodeIfPresent(at: "profile.birth_day", using: DateFromString(format: "yyyy/MM/dd"))
    avatar = try decoder.decodeIfPresent(at: "profile.avatar")
    salary = try decoder.decode(at: "salary", using: SalaryTransformer())
    isMale = try decoder.decode(at: "male", using: { $0 == "true" ? true : false })
  }
}

let user = try JSONDecoder().decode(User.self, from: json, at: "response.users[0]")
```

### Transformer

A Transformer used in decoder is used to transform a raw value (Which is a Decodable type) from json into another data type.

Look backward to the example, we transform "salary" (which is a String type) into an enum called Salary, which is more expressive and readble.



### Term

##### Path

A **path** is used to decribe the coding path, It can be expressed by string literals, a path should look like

```	json
"response[0]users[1]name"
```

or

```swift
"response[0].users[1].name"
```

or

```swift
"response.[0].users.[1].name"
```

Among them, "response"、"[0]"、"users"、"[1]"、"name" we call **PathComponent**, the PathComponent "[0]"、"[1]" will be treated as an **Index PathComponent** (which is used to indicate the index to be decoded in an UnkeyedContainer), others will be treated as **Key PathComponent** (which is used to indicate the key to be decoded in a KeyedContainer).

**PathComponent can join togather to represent a path with a separator (which is "." by default, and can be configured  in the initializer of Path.)** So if you have a dot-contained json key, you can use another separate instead.

### FAQ

##### 1、As the path treat dot as separator, so how to decode a json witch contain dot-contained key?

One of the solutions is to init a Path specify the separator.

Another way is to make a Path using [PathComponent].

```swift
let json = """
{
  "response": {
    "my.user": {
      "name": "Jerry"
    }
  }
}
""".data(using: .utf8)!

struct User: Decodable {
  let name: String
}

/* A Path specify the separator */
let user = try JSONDecoder().decode(User.self, from: json, at: Path("response/my.user", separator: "/"))

/* A Path using [PathComponent] */
let user = try JSONDecoder().decode(User.self, from: json, at: Path(["respsonse", "my.user"]))
```

