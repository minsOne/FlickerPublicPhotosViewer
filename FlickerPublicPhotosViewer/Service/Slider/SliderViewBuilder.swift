//
//  SliderViewBuilder.swift
//  FlickerPublicPhotosViewer
//
//  Created by minsone on 03/12/2018.
//

import Foundation
import UIKit

class SliderViewBuilder {
    init() {}
    
    func build() -> UIViewController {
        let vc: SliderViewController = UIStoryboard.slider.instantiateViewController()
        
        vc.reactor = SliderViewReactor(changeSliderShowDurationService: NumberPromptService())
        return vc
    }
}
