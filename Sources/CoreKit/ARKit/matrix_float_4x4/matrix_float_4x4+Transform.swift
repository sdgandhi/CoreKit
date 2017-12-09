//
//  matrix_float_4x4+Transform.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 10. 27..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS)

    import GLKit
    import CoreLocation.CLLocation
    import SceneKit

    // matrix_float4x4 = simd_float4x4
    public extension matrix_float4x4 {

        public func translationMatrix(for translation: vector_float4) -> matrix_float4x4 {
            var matrix = self
            matrix.columns.3 = translation
            return matrix
        }

        public func rotateAroundY(for degrees: Float) -> matrix_float4x4 {
            var matrix = self
            matrix.columns.0.x = cos(degrees)
            matrix.columns.0.z = -sin(degrees)
            matrix.columns.2.x = sin(degrees)
            matrix.columns.2.z = cos(degrees)
            return matrix.inverse
        }

        public func transformMatrix(originLocation: CLLocation, location: CLLocation) -> matrix_float4x4 {
            let distance = Float(location.distance(from: originLocation))
            let bearing = originLocation.bearing(to: location)
            let position = vector_float4(0.0, 0.0, -distance, 0.0)
            let translationMatrix = matrix_identity_float4x4.translationMatrix(for: position)
            let rotationMatrix = matrix_identity_float4x4.rotateAroundY(for: Float(bearing))
            let transformMatrix = simd_mul(rotationMatrix, translationMatrix)
            return simd_mul(self, transformMatrix)
        }

        public var position: SCNVector3 {
            let vector = self.columns.3
            #if os(iOS) || os(tvOS) || os(watchOS)
                return SCNVector3(x: vector.x, y: vector.y, z: vector.z)
            #endif
            #if os(macOS)
                return SCNVector3(x: CGFloat(vector.x), y: CGFloat(vector.y), z: CGFloat(vector.z))
            #endif
        }
    }

#endif
