class Timesheet
  attr_reader :total_commits, :data
  
  def initialize category_name, month, year
    category = Category.first(:name => category_name)
    if category.nil?
      raise "Category #{category_name} not found"
    else
      @data = generate_timesheet(category, month, year)
    end
  end
  
  private
    def generate_timesheet(cat, month, year)
      @total_commits = 0
      sheet = []
      cat.projects.each do |project|
        project.init()
        commits = project.commits_by_month_and_year(month, year)
        sheet << { :title => project.title, :commits_made => commits.count }
        @total_commits += commits.count
      end
      sheet.each do |entry|
        percentage = entry[:commits_made].to_f / @total_commits * 100
        entry[:percentage] = (sprintf "%.2f", percentage).to_f
      end
      sheet.delete_if { |x| x[:commits_made] == 0 }
    end
end