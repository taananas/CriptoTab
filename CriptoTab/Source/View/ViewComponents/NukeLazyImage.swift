//
//  NukeLazyImage.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 14.03.2023.
//

import SwiftUI
import NukeUI
import Nuke

struct NukeLazyImage: View{
    
    private var url: URL?
    var strUrl: String?
    var resizeHeight: CGFloat = 200
    var resizingMode: ImageResizingMode = .aspectFill
    var loadPriority: ImageRequest.Priority = .normal
    private let imagePipeline = ImagePipeline(configuration: .withDataCache)
    
    init(strUrl: String?,
         resizeHeight: CGFloat = 200,
         resizingMode: ImageResizingMode = .aspectFill,
         loadPriority: ImageRequest.Priority = .normal){
        self.strUrl = strUrl
        self.resizeHeight = resizeHeight
        self.resizingMode = resizingMode
        self.loadPriority = loadPriority
        
        if let strUrl = strUrl{
            self.url = URL(string: strUrl)
        }
       
    }
    var body: some View{
        Group{
            if let url = url {
                LazyImage(source: url) { state in
                    if let image = state.image {
                        image
                    }else  if state.isLoading{
                        Color.secondary.opacity(0.5)// Acts as a placeholder
                    }else if let _ = state.error{
                        Color.secondary.opacity(0.5) // Error
                    }
                }
                .processors([ImageProcessors.Resize.resize(height: resizeHeight)])
                .priority(loadPriority)
                .pipeline(imagePipeline)
            }else{
                //Color.secondary.opacity(0.5)
            }
        }
    }
}
