//
//  FirstViewController.m
//  SimpleChart
//
//  Created by Raj on 2/15/16.
//  Copyright © 2016 Raj. All rights reserved.
//

#import "FirstViewController.h"
#import "DateHelper.h"
#import "DoubleChartPointValue.h"
#import "SimpleChart.h"
#import "SimpleBarChart.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)loadView
{
    [super loadView];
    self.view.clipsToBounds = NO;

    SimpleBarChart *chartView = [[SimpleBarChart alloc] initWithFrame: CGRectMake(0, 30, self.view.bounds.size.width, 300)];
    [chartView setLabelProvider: self];
    [self addChart: chartView numberOfPoints: 20];

    SimpleChart *chartView2 = [[SimpleChart alloc] initWithFrame: CGRectMake(0, 330, self.view.bounds.size.width, 300)];
    [chartView2 setLabelProvider: self];
    [self addChart: chartView2 numberOfPoints: 20];
}

- (void)addChart: (SimpleChart *) chartView numberOfPoints: (NSUInteger) numberOfPoints
{
    chartView.clipsToBounds = NO;
    [self.view addSubview: chartView];

    int date = [DateHelper localDaySinceReferenceDate] - (int) numberOfPoints;
    NSMutableArray *testArray = [NSMutableArray arrayWithCapacity: numberOfPoints];
    for (int i = 0; i <= numberOfPoints; i += 1)
    {
        int r = 5 + arc4random() % 50;

        [testArray addObject: [SimpleChartPointValue simpleChartPointValueWithX: date + i Y: r]];
    }

    [chartView setChartPointValue: testArray];
}

- (NSString *)labelForXValue: (CGFloat) xValue
{
    NSDate *date = [DateHelper dateFromlocalDaySinceReferenceDate: (int) xValue];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat: @"MMM-d"];
    return [format stringFromDate: date];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
