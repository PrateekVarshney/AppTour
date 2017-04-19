
# ```AppTour```

AppTour is a lighweight library to integrate onboarding or app tutorial. It uses the actual app screens to inform the user what each element in the screen does.
<br/><br/>
Highlight a button, a view, a label or anything that you want.
<br/><br/>

# Contents
* [Getting Started](#getting-started)
* [Requirements](#requirements)
* [Usage](#usage)
* [Upcoming](#upcoming)

# Getting Started
* Clone the repo or download the `source code` and add the `'AppTour.framework'` file in your source code. Make sure to add the framework in the embedded binaries section.
<br/>
OR
* Use `Cocoa pods` to integrate.
Add pod `'AppTour'` in your pod file and run pod install.
<br/><br/>

# Requirements
* iOS 8 and above
* Xcode 7 and above

# Usage
Copy the follwing lines in you ViewController
> import AppTour

Add the following line in your viewDidLoad method.
> let appTour : AppTour = AppTour()

Add the following line in your viewDidAppear method. The first argument is the view controller reference and second argument should be the view/button that needs to be highlighted
> appTour.showOnBoardingView(viewController: self, view: self.titleLabel, isViewInTable: false, tableObj: nil, indexPath: nil)

# Upcoming
Will add screenshots asap
<br/>
Will keep adding more functionalities and documentation.
