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

Tạo button bar trái phải 

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
