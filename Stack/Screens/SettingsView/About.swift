//
//  About.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/20/25.
//

import SwiftUI

struct About: View {
    
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-render-markdown-content-in-text
    
    let aboutString: LocalizedStringKey = """
        Stack is an unnofficial fan made app permitted under the [Fan Content Policy](https://company.wizards.com/en/legal/fancontentpolicy). Portions of the materials used are property of Wizards of the Coast.
        
        Card data is provided by [Scryfall](https://scryfall.com/docs/api).
        """

    let kfString: LocalizedStringKey = """
        Kingfisher
                
        The MIT License (MIT)
        
        Copyright (c) 2019 Wei Wang
        
        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
        
        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
        
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
        """
    
    let gzString: LocalizedStringKey = """
        GzipSwift
        
        The MIT License (MIT)

        © 2014-2026 1024jp

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
        """
    
    let sdString: LocalizedStringKey = """
        SwiftDraw
        
        zlib License
        
        Copyright (c) 2019 Simon Whitty

        This software is provided 'as-is', without any express or implied warranty.  In no event will the authors be held liable for any damages arising from the use of this software.

        Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
        2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
        3. This notice may not be removed or altered from any source distribution.
        """
    
    var body: some View {
        ScrollView {
            Group {
                Text(aboutString)
                    .handleOpenURLInApp()
                    .padding(.bottom, 10)
                Divider()
                Text(kfString)
                    .padding(.vertical, 10)
                Divider()
                Text(gzString)
                    .padding(.top, 10)
                Divider()
                Text(sdString)
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .navigationTitle("Acknowledgements")
        }
    }
}

#Preview {
    About()
}
