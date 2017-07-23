//
//  Generator.swift
//  XcodeGen
//
//  Created by Yonas Kolb on 19/5/17.
//
//

import Foundation
import PathKit
import xcodeproj
import xcodeprojprotocols
import JSONUtilities
import Yams

public class ProjectGenerator {

    let spec: Spec
    let pbxProjGenerator: PBXProjGenerator

    public init(spec: Spec) {
        self.spec = spec
        pbxProjGenerator = PBXProjGenerator(spec: spec)
    }

    public func generate() throws -> XcodeProj {
        let pbxProject = try pbxProjGenerator.generate()
        let workspace = try generateWorkspace()
        let sharedData = try generateSharedData()
        return XcodeProj(workspace: workspace, pbxproj: pbxProject, sharedData: sharedData)
    }

    func generateWorkspace() throws -> XCWorkspace {
        let workspaceReferences: [XCWorkspace.Data.FileRef] = [XCWorkspace.Data.FileRef.project(path: Path(""))]
        let workspaceData = XCWorkspace.Data(references: workspaceReferences)
        return XCWorkspace(data: workspaceData)
    }

    func generateSharedData() throws -> XCSharedData {
        let schemes: [XCScheme] = spec.schemes.map { schemeSpec in
            //            let buildEntries: [XCScheme.BuildAction.Entry] = schemeSpec.build.entries.map { build in
            //                let buildableReference: XCScheme.BuildableReference? = nil
            //                return XCScheme.BuildAction.Entry(buildableReference: buildableReference!, buildFor: build.buildTypes)
            //            }
            let buildAction = XCScheme.BuildAction(buildActionEntries: [], parallelizeBuild: true, buildImplicitDependencies: true)

            return XCScheme(name: schemeSpec.name, lastUpgradeVersion: nil, version: nil, buildAction: buildAction, testAction: nil, launchAction: nil, profileAction: nil, analyzeAction: nil, archiveAction: nil)
        }

        return XCSharedData(schemes: schemes)
    }
}
