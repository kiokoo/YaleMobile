YaleMobile
==========

Welcome to YaleMobile, the first and best iOS app for Yale University students!

## Components

YaleMobile currently have the following components:

* **Bluebook**, the course catalog of Yale University. Its web version can be accessed at yale.edu/oci.
* **Dining**, including dining hall status and menu.
* **Campus Map**, featuring a Yale-specific map that supports searching by abbreviations.
* **Shuttle**, real-time Yale Shuttle status. Data provided by TransLoc.
* **People Directory**, where you can find all Yale personnel. The web version can be found at directory.yale.edu/phonebook/index.htm.
* **Laundry**, real-time laundry machine status across Yale campus. Data provided by MacGray Corporation.
* **Facility hours**, live libary hours provided by Yale University Library, and hours of other facilities such as gym and retail dining locations.
* **Calendar**, the academic calendars of all schools in Yale.
* **Phonebook**, where you can find numbers of all departments, offices and the like.

If you are a Yale student and you have a new feature in mind, please either open an issue or email us at yale.mobile.app@gmail.com.

## Code

All code for the app is in this repository, and grouped into components outlined above. Since TransLoc and MacGray LaundryView are services provided to other institutions as well, you may find code related to them particularly useful.

YaleMobile uses several open source libraries, including:

* **AFNetworking**, the de facto standard networking library for iOS.
* **SWRevealViewController**, a side menu library.
* **Mantle**, GitHub's model library for iOS, which is easier to use than Core Data (sans persistent).

Check out the podfile to see the most up-to-date list. The maintainer of the repository should make sure all libraries are listed here.


## Credits

### Version 3

* Code: Hengchu Zhang, Danqing Liu, Jenny Allen, cmwalther.
* Graphics: Danqing Liu.

### Version 2

* Make: Danqing Liu.
* Photography: Yingqi Tan, Jian Li, Hengchu Zhang, Tong Zuo, Yinshuo Zhang, Linda Lai.
* Special thanks: Jing Han, Christina Zhang, Edwin Bebyn, Adam Bray.

### Version 1

* Make: Danqing Liu.
* Photography: Yingqi Tan, Jian Li.
* Special thanks: Sherwin Yu, Bryan Ford, Sijia Song, Simon Song.

YaleMobile started as a personal project of Danqing Liu in 2012 and became a YaleSTC sponsored project in 2014. Yale University does not officially endorse the app, and has its own, official iOS app.

## License

MIT.