//
//  SelectViewController.m
//  AqarEasy
//
//  Created by ITS Mobile Banking on 10/14/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "SelectViewController.h"
#import "Utility.h"
@interface SelectViewController ()
{
    UITableViewCell *LastSelectedCell;
}
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
       cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.textLabel.text=_arrData[indexPath.row][@"name"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LastSelectedCell.accessoryType=UITableViewCellAccessoryNone;
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    
    LastSelectedCell=cell;
}

-(IBAction)selectRow:(id)sender{
    
    NSIndexPath *indexPath=[TBL_select indexPathForSelectedRow];
    if (indexPath) {
        if (_delgate) {
            if ([_delgate respondsToSelector:@selector(tableSelctedWithResult:)]) {
                [_delgate tableSelctedWithResult:_arrData[indexPath.row]];
            }
        }

    }else{
        [Utility ShowAlertWithTitle:@"" andMsg:@"من فضلك اختر" andType:SWarning];
    }
}

-(IBAction)cancelSelect:(id)sender{
    if (_delgate) {
        if ([_delgate respondsToSelector:@selector(userCancelSelect)]) {
            [_delgate userCancelSelect];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
