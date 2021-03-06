$(document).on('turbolinks:load', function() {
  if ($('body')[0].className == 'dashboard index') {
    var netIncomeCtx = document.getElementById('netIncome');
    var netIncomeChart = new Chart(netIncomeCtx, {
      type: 'line',
      data: {
        labels: $('#income_months').val().split(','),
        datasets: [
          {
            label: "Rental Income",
            fill: false,
            lineTension: 0.1,
            backgroundColor: "rgba(75,192,192,0.4)",
            borderColor: "rgba(75,192,192,1)",
            borderCapStyle: 'butt',
            borderDash: [],
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBorderColor: "rgba(75,192,192,1)",
            pointBackgroundColor: "#fff",
            pointBorderWidth: 2,
            pointHoverRadius: 6,
            pointHoverBackgroundColor: "rgba(75,192,192,1)",
            pointHoverBorderColor: "rgba(220,220,220,1)",
            pointHoverBorderWidth: 2,
            pointRadius: 6,
            pointHitRadius: 10,
            data: $('#income').val().split(','),
            spanGaps: false,
          }
        ]
      }
    });

    var propertyCtx = document.getElementById('property');
    var propertyChart = new Chart(propertyCtx, {
      type: 'pie',
      data: {
        labels: ['Rented properties', 'Vacant properties'],
        datasets: [{
          label: 'Properties',
          data: $('#property_count').val().split(','),
          backgroundColor: [
            'rgba(74, 255, 46, 0.3)',
            'rgba(255, 99, 132, 0.2)',
          ],
          backgroundColor: [
            "#36A2EB", // blue
            "#FF6384", // red
          ],
        }]
      },
    });


    var expensesCtx = document.getElementById('expenses');
    var expensesChart = new Chart(expensesCtx, {
      type: 'bar',
      data: {
        labels: $('#account_keys').val().split(','),
        datasets: [{
          label: 'Expenses',
          data: $('#account_data').val().split(','),
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)'
          ],
          borderColor: [
            'rgba(255,99,132,1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)'
          ],
          borderWidth: 1
        }]
      },
    });
  }
});
