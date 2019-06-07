//  This file was automatically generated and should not be edited.

import Apollo

public final class UserInfoQuery: GraphQLQuery {
  public let operationDefinition =
    "query UserInfo {\n  me {\n    __typename\n    id\n    name\n    email\n    path\n    resourceUrl\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("me", type: .object(Me.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(me: Me? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "me": me.flatMap { (value: Me) -> ResultMap in value.resultMap }])
    }

    /// The currently authenticated user
    public var me: Me? {
      get {
        return (resultMap["me"] as? ResultMap).flatMap { Me(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "me")
      }
    }

    public struct Me: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("path", type: .nonNull(.scalar(String.self))),
        GraphQLField("resourceUrl", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, email: String? = nil, path: String, resourceUrl: String) {
        self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "email": email, "path": path, "resourceUrl": resourceUrl])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The ID of an object
      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// The user's profile name
      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// The user's profile email
      public var email: String? {
        get {
          return resultMap["email"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "email")
        }
      }

      /// The Http URL for the user
      public var path: String {
        get {
          return resultMap["path"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "path")
        }
      }

      /// The Http URL for the user
      public var resourceUrl: String {
        get {
          return resultMap["resourceUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "resourceUrl")
        }
      }
    }
  }
}