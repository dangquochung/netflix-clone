#Nhật ký Netflix Clone 


Mô hình MVVM
1. #Tạo tabbar đầu tiên: 

Set root view cho tabbar: UiTabbarController (xóa main storyboard và rename viewcontroller ban đầu )
Tabbar sẽ có 4 phần => tạo mới 4 viewcontroller
Khai báo từng viewcontroller trong tabbarViewController
Custom tabbar: backgroundcolor, icon, title
Set tintcolor cho title
Set viewControllers cho tabbar
***
2. #Setting HomeViewController TabblerView 
Tạo mới tableView (cho home feed) register tableViewcell và addsubview 
Khi tạo tableview
Đầu tiên phải register cell 
Sau đó gán delegate và datasource
Bắt buộc 

Delegate xử lý sự kiện của tableview
Datasource xử lý dữ liệu và cách hiển thị của tableview

~~~
tableView.delegate = self
~~~

Delegate: cho phép chuyển trách nhiệm/sự kiện cho 1 đối tượng khác 
Giúp các đối tượng tương tác với nhau mà ko cần biết quá nhiều về nhau 
Khi gán như  trên, nói rằng đối tượng hiện tại self là viewcontroller sẽ đảm nhận nhiệm vụ được đặt ra bởi UITableViewDelegate 
Tương tự với datasource
***

3. #Thiết lập tableviewcell custom
Tạo cocoatouchclass tableviewcell
- Đặt định danh cho cell
- Khởi tạo và đặt lỗi 

~~~
override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init(coder: NSCoder) {
        fatalError()
    }
~~~

Giải thích đoạn code trong UITableViewCell:
1. override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?):
* Đây là phương thức khởi tạo (initializer) được gọi khi bạn tạo một UITableViewCell trực tiếp trong code.
* Nó nhận hai tham số:
    * style: Kiểu dáng của cell (ví dụ: .default, .value1, .subtitle).
    * reuseIdentifier: Mã định danh để tái sử dụng cell, giúp tiết kiệm bộ nhớ và cải thiện hiệu suất.
* Nó gọi đến phương thức khởi tạo của lớp cha (super.init(style: style, reuseIdentifier: reuseIdentifier)) để thực hiện các thiết lập cơ bản của cell.
2. required init(coder: NSCoder):
* Đây là một phương thức khởi tạo bắt buộc theo giao thức NSCoding, được sử dụng để giải mã các đối tượng từ file lưu trữ.
* Trong đoạn code này, phương thức này được triển khai để ném ra một lỗi nghiêm trọng (fatalError()), ngăn chặn việc khởi tạo cell từ file lưu trữ. Điều này thường được thực hiện khi cell được thiết kế để được tạo trực tiếp trong code và không cần thiết phải lưu trữ hoặc giải mã từ file.

Ở homeviewController

~~~
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
~~~

Các bước thực hiện:
1. Tái sử dụng cell:
    * tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath):
        * Tìm kiếm một cell đã được tạo trước đó với mã định danh CollectionViewTableViewCell.identifier.
        * Nếu tìm thấy, cell đó sẽ được tái sử dụng để tiết kiệm bộ nhớ.
        * Nếu không tìm thấy, một cell mới sẽ được tạo ra.
    * as? CollectionViewTableViewCell: Ép kiểu cell thành CollectionViewTableViewCell, đảm bảo cell thu được là loại mong muốn để sử dụng các tính năng đặc thù của nó.
2. Xử lý lỗi nếu ép kiểu thất bại:
    * guard let cell = ... else { return UITableViewCell() }:
        * Nếu không thể ép kiểu thành CollectionViewTableViewCell, đoạn code sẽ trả về một cell mặc định (UITableViewCell()) để tránh lỗi.
3. Trả về cell:
    * return cell: Trả về cell đã được tái sử dụng hoặc tạo mới để table view hiển thị.
Mục đích:
* Tạo và cung cấp các cell cho table view để hiển thị nội dung.
* Tái sử dụng các cell đã được tạo để tiết kiệm bộ nhớ và tăng hiệu suất.
* Đảm bảo cell thu được là loại mong muốn để có thể sử dụng các tính năng đặc thù của nó.
Lưu ý:
* CollectionViewTableViewCell có thể là một custom cell được tạo riêng cho dự án.
* Việc sử dụng guard let giúp đảm bảo an toàn và rõ ràng trong việc xử lý lỗi.
* Phương thức này là một phần quan trọng của việc hiển thị dữ liệu trong table view.

***
4. Setting home tableViewCell là collectionView
Setup collectionView với itemSize và scrollDirection, đồng thời register cell 
addSubview cho collectionview 
Gán delegate và datasource 
Setup cellForItemAt và numberOfItemInsection 

***
5. Customize navigation bar 

~~~
configureNavbar()

~~~

Tạo button bar tray phải 

~~~
 private func configureNavbar() {
         var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
~~~

Ý tưởng là khi kéo scrollview ở Home xuống dưới thì navigationbar hiển thị và giữ nguyên, nhưng nếu kéo ngược lại đẩy lên trên thì navigationBar sẽ ẩn đi 

~~~
func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        }
~~~

***
6. Custom header of section in tableview at homeviewcontroller
Ý tưởng là có 1 chuỗi các title 

~~~
let sectionTitles: [String] = ["Trending Movies","Popular", "Trending TV", "Upcoming Movies", "Top Rated"]
~~~

Rồi sau đó truyền vào tableview thông qua 

~~~
func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
~~~

Tiếp tục custom font chữ và vị trí và màu của text label header
Hàm này sử dụng đc cho cả header và footer

~~~
func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
    }
~~~

***
7. Sending URL request and parsing json response

Ý tưởng là lấy data từ API
Đầu tiên phải có API_KEY và baseURL
Quan Sát data và đưa ra các thuộc tính của Movie
Cài đặt Model cho Movie, Cài đặt APICaller sử dụng gọi api bằng URLSession 
Mô hình hóa data, decode data dựa trên model vừa tạo 
sử dụng closure Result<[Movie], Error>

~~~
class APICaller {
    //tao 1 the hien cuar lop APICaller de co the acess cac tai nguyen trong lop nay
    static let shared = APICaller()
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
    guard let url = URL(string: "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.API_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
~~~

Gọi ra ở VIewController (thực ra nên gọi ở ViewModel và bắn data sang ViewController, sẽ update sau )

~~~
private func getTrendingMovies() {
        APICaller.shared.getTrendingMovies { results in
            switch results {
            case .success(let movies):
                print(movies)
            case .failure(let error):
                print(error)
            }
        }
    }
~~~

***

8. Capitalize First Letter
Ý tưởng là chỉ viết hoa chữ cái đầu của title header of section, viết hoa chữ cái đầu + phần còn lại lower và bỏ chữ cái đầu

~~~
extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
~~~

***

9. Consuming API to fetch data to each section
Ý tưởng là tạo ra hàm fetch data cho mỗi section tương ứng (lấy trên movie db)
VD

~~~
func getTrendingTvs(completion: @escaping (Result<[TV], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTVResponse.self, from: data)
                print(results)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
~~~

***
10. Thêm ảnh cho collection view cell

Ý tưởng là sử dụng sdwebimage để hiển thị ảnh trong cell

Thêm package từ link 

~~~
https://github.com/SDWebImage/SDWebImage.git
~~~

Setup collection viewcell bằng view riêng TitleCollectionViewCell, bao gồm imageview 
Configure imageview nhận ảnh từ api 

~~~
public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
~~~

Ở tableviewcell
Khai báo data với dạng chuỗi rỗng và đăng ký cell identifier = TitleCollectionViewCell

~~~
private var titles: [Title] = [Title]()
~~~

Configure data và reload collectionview 

~~~
public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
~~~

Config collectionview cell 

~~~
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
~~~

Ở HomeViewController, setup cellForRowAt, fill data từ api cho mỗi section trả về 

~~~
switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
~~~

***

11. Create upcoming tableview inside upcoming view
Ý tưởng là: tạo tableview bên trong view upcoming, cấu hình table và fetchdata tương tự homeview

Khai báo title dạng chuỗi rỗng 

~~~
private var titles: [Title] = [Title]()
~~~

Tạo tableview, gán delegate/datasource

~~~
table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
upcomingTable.delegate = self
upcomingTable.dataSource = self
~~~

Fetch data

~~~
private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
~~~

Gán data vào cell 

~~~
cell.textLabel?.text = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "Unknow"
~~~

***

12.  Fetch data vão upcoming view và cai đặt hiển thị view

Tạo view model 

~~~
struct TitleViewModel {
    let titleName: String
    let posterURL: String 
}
~~~

Tạo tableviewcell với image/label/button + constraint them 
Tạo hàm configure gán data ảnh/title vào cell 

~~~
public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        titlePosterUIImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    }
~~~

Cài đặt tablerow 

~~~
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknow", posterURL: title.poster_path ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
~~~

***

13.  Creating top search tableview inside top search tab
Về nguyên lý làm giống ko khác gì so với tableview trong upcoming view

***

14. Creating searchResultsViewController to display search results
Ý tưởng là:
- Thêm searchbar vào discoverView (SearchView) khi tab vào searchbar sẽ hiển thị searchresultviewcontroller, tab ra ngoài hoặc xóa hết thì ẩn view đó đi 

~~~
private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a movie or a tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
~~~

- Thêm searchResult viewcontroller bao gồm collection view full frame

~~~
private let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
~~~

***

14. Querying database for individual movie 
Ý tưởng configure api search with string

~~~
func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        //đề phòng lỗi query
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        //https://api.themoviedb.org/3/search/movie?query=Jack+Reacher&api_key=1fa244b2c0707c1930e3912ac563b85a
        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?query=\(query)&api_key=\(Constants.API_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
~~~

- Gán delegate cho search controller 

~~~
searchController.searchResultsUpdater = self
~~~

- Tuân thủ protocol của searchresultupdating, truyền data kết quả về resultcontroller (from searchviewcontroller) + reload collectionresult

~~~
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
~~~

*** 

15. Using YouTube api:

B1: Vào google deve console
B2: Vào Credentials -> Create project , đặt tên 
B3: Create Credentials -> api key created , để truy cập YouTube api 
B4: Kích hoạt api YouTube -> chọn tab Enabled APIs & Services -> click Enabled APIs & Services
B5: Scroll down thấy thì click vào Youtube Data API v3, click Enable => show api service detail page 
B6: Back về tab Credentials -> copy key 
B7: Vào trang https://developers.google.com/youtube/v3?hl=vi, vào phần Search for content, hiện ra danh sách api của YouTube 
B8: Scroll down cột bên phải, nhấn vào button SHOW CODE, rồi click vào tab HTTP
B9: Copy link get https://youtube.googleapis.com/youtube/v3/search?q=harry&key=[YOUR_API_KEY]

- Setting api call

~~~
func getMovie(with query: String) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        //https://youtube.googleapis.com/youtube/v3/search?q=harry&key=[YOUR_API_KEY]
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(results)
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
~~~

Test 

~~~
 APICaller.shared.getMovie(with: "harry potter")
~~~

16. Parsing Youtube API response


~~~
/*
 items =     (
             {
         etag = "nokcGt9OrQ0QycurR_Z6fJV5eFQ";
         id =             {
             kind = "youtube#video";
             videoId = LbKIKjgfT90;
         };
         kind = "youtube#searchResult";
     },
 */
 ~~~
 
 ~~~
struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}
struct VideoElement: Codable {
    let id: IdVideoElement
}
struct IdVideoElement: Codable {
    let kind: String
    let videoId: String?
    let channelId: String?
}
~~~

~~~
func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        //https://youtube.googleapis.com/youtube/v3/search?q=harry&key=[YOUR_API_KEY]
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
//                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            }
            catch {
                completion(.failure(error))
               print(error.localizedDescription)
            }
        }
        task.resume()
    }
~~~


*** 

17. Handling selection of cell and create title preview controller

Ý tưởng là khi selection cell sẽ push ra title previewcontroller và hiển thị video preview Kim name và review content

Tạo ra delegate khi didtapcell 

~~~
protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}
weak var delegate: CollectionViewTableViewCellDelegate?
~~~

Ở collectiontableviewcell, xử didtapcell, gọi api gồm name+ trailer , nhận được data trả về, format data dưới dạng titlepreviewmodel và perform delegate để thực hiện lệnh bên trong

~~~
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
~~~

Triển khai hành động trong didtapcell , configure và pushview, hàm configure để load video preview bằng url đc api trả về

~~~
extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            print("Invalid URL")
            return
        }
        print("check URL>>>\(url)")
        webView.load(URLRequest(url: url))
    }
~~~

***

18. Refactoring TableviewHeader Hero Title

Ý tưởng là: headerview đang bên trong viewdidload đưa ra bên ngoài , muốn random movie trên header view
Tạo biến random 

~~~
private var randomTrendingMovie: Title?
~~~

Tạo hàm lấy movie trên header bằng cách lấy trending movie + random 1 trong các movie đó để hiển thị lên header 


~~~
private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
~~~

***

19. Handling Tapping across all viewcontrollers

Ý tưởng 1  là khi tap vào các cell kết quả của upcoming và search thì đều nhảy sang titlepreviewcontroller
Tạo protocol chưa actiondidtap

~~~
protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}
public weak var delegate: SearchResultViewControllerDelegate?
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultViewControllerDidTapItem(TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
~~~

Implement protocol
~~~
resultController.delegate = self
func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
~~~

Ý tưởng 2 là khi nhấn giữ vào cell kết quả của upcoming sẽ hiển thị lên menu action download

~~~
func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                    let downloadAction = UIAction(
                        title: "Download",
                        subtitle: nil,
                        image: nil,
                        identifier: nil,
                        discoverabilityTitle: nil,
                        state: .off
                    ) { _ in
                        print("download tapped")
                    }
                return UIMenu(
                    title: "",
                    image: nil,
                    identifier: nil,
                    options: .displayInline,
                    children: [downloadAction]
                )
            }
        return config
    }
~~~

20. Core Data

